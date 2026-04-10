import SwiftUI
import AVFoundation
import Photos
import UIKit
import Combine

@MainActor
final class MyProfileViewModel: ObservableObject {
    enum ProfileImageSource: String, Identifiable {
        case photoLibrary
        case camera

        var id: String { rawValue }
    }

    enum Option: String {
        case posted = "Posted"
        case visited = "Visited"
        case favourites = "Favourites"
    }

    // MARK: - Fields
    @Published var selectedOption: Option
    @Published var username: String
    @Published var draftUsername: String = ""
    @Published var bio: String
    @Published var draftBio: String = ""
    @Published var posts: [ArtItem]
    @Published var visited: [ArtItem]
    @Published var favourites: [ArtItem]

    // logout state (feature/authotization-service)
    @Published var showLogoutError: Bool = false
    @Published var isLoggingOut: Bool = false
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false
    @AppStorage("isLoggedIn") var isLoggedIn = false

    // profile image + permissions state (main)
    @Published var profileImage: UIImage?
    @Published var isImageSourceDialogPresented: Bool = false
    @Published var activeImagePickerSource: ProfileImageSource?
    @Published var isPermissionAlertPresented: Bool = false
    @Published var permissionAlertMessage: String = ""
    @Published var shouldOfferSettingsRedirect: Bool = false
    @Published var isEditingUsername: Bool = false
    @Published var isEditingBio: Bool = false
    @Published var isProfileSyncInProgress: Bool = false

    private let authorizationService: AuthorizationService
    private let imageLoaderService: ImageLoaderService
    private let userService: UserService
    private let tokenStore: SessionTokenStoring
    private var hasLoadedProfile: Bool = false

    var selectedOptionTitle: String {
        selectedOption.rawValue
    }

    var shouldDisplayAddButton: Bool {
        selectedOption == .posted
    }

    var displayedItems: [ArtItem]? {
        switch selectedOption {
        case .posted:
            return posts
        case .visited:
            return visited
        case .favourites:
            return favourites
        }
    }

    // MARK: - Lifecycle
    init(
        authorizationService: AuthorizationService,
        imageLoaderService: ImageLoaderService,
        userService: UserService,
        tokenStore: SessionTokenStoring? = nil,
        selectedOption: Option = .posted,
        username: String = "Username",
        bio: String = "Description",
        posts: [ArtItem] = [],
        visited: [ArtItem] = [],
        favourites: [ArtItem] = [],
    ) {
        self.authorizationService = authorizationService
        self.imageLoaderService = imageLoaderService
        self.userService = userService
        self.tokenStore = tokenStore ?? SessionTokenStore()
        self.selectedOption = selectedOption
        self.username = username
        self.bio = bio
        self.posts = posts
        self.visited = visited
        self.favourites = favourites
    }

    // MARK: - Logic
    func selectOption(_ option: Option) {
        selectedOption = option
    }

    func onAppear() {
        guard !hasLoadedProfile else { return }
        hasLoadedProfile = true
        Task {
            await loadCurrentUserProfile()
        }
    }

    // MARK: - Logout
    func logout() {
        guard !isLoggingOut else { return }
        isLoggingOut = true

        Task {
            defer {
                Task { await MainActor.run {
                    self.isLoggingOut = false
                } }
            }

            await authorizationService.logoutCurrentSession()

            withAnimation(Motion.standard) {
                self.isLoggedIn = false
                self.hasCompletedOnboarding = false
            }
        }
    }

    // MARK: - Profile text editing
    func enterUsernameEditingMode() {
        draftUsername = username
        isEditingUsername.toggle()
    }

    func saveUsername() {
        let newUsername = draftUsername.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !newUsername.isEmpty else {
            presentPermissionAlert(
                message: "Username can not be empty.",
                offerSettingsRedirect: false
            )
            return
        }

        guard newUsername != username else {
            isEditingUsername = false
            return
        }

        Task {
            do {
                isProfileSyncInProgress = true
                let token = try requireToken()
                let profile = try await userService.changeUsername(token: token, username: newUsername)
                applyProfile(profile)
                isEditingUsername = false
            } catch let error as APIErrorResponse {
                presentPermissionAlert(message: error.errorMessage, offerSettingsRedirect: false)
            } catch {
                presentPermissionAlert(
                    message: "Could not update username. Please try again.",
                    offerSettingsRedirect: false
                )
            }
            isProfileSyncInProgress = false
        }
    }

    func enterBioEditingMode() {
        isEditingBio.toggle()
        draftBio = bio
    }

    func saveBio() {
        let newBio = draftBio.trimmingCharacters(in: .whitespacesAndNewlines)
        guard newBio != bio else {
            isEditingBio = false
            return
        }

        Task {
            do {
                isProfileSyncInProgress = true
                let token = try requireToken()
                let profile = try await userService.changeBio(token: token, bio: newBio)
                applyProfile(profile)
                isEditingBio = false
            } catch let error as APIErrorResponse {
                presentPermissionAlert(message: error.errorMessage, offerSettingsRedirect: false)
            } catch {
                presentPermissionAlert(
                    message: "Could not update bio. Please try again.",
                    offerSettingsRedirect: false
                )
            }
            isProfileSyncInProgress = false
        }
    }

    // MARK: - Profile image flow
    func presentProfileImageOptions() {
        isImageSourceDialogPresented.toggle()
    }

    func dismissProfileImageOptions() {
        isImageSourceDialogPresented = false
    }

    func choosePhotoLibrary() {
        dismissProfileImageOptions()
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)

        switch status {
        case .authorized, .limited:
            activeImagePickerSource = .photoLibrary
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
                DispatchQueue.main.async {
                    guard let self else { return }

                    if status == .authorized || status == .limited {
                        self.activeImagePickerSource = .photoLibrary
                    } else {
                        self.presentPermissionAlert(
                            message: "Allow access to your photo library to choose a profile picture.",
                            offerSettingsRedirect: true
                        )
                    }
                }
            }
        case .denied, .restricted:
            presentPermissionAlert(
                message: "Photo library access is disabled. You can enable it in Settings.",
                offerSettingsRedirect: true
            )
        default:
            presentPermissionAlert(
                message: "Photo library access is unavailable right now.",
                offerSettingsRedirect: false
            )
        }
    }

    func chooseCamera() {
        dismissProfileImageOptions()
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            presentPermissionAlert(
                message: "Camera is not available on this device.",
                offerSettingsRedirect: false
            )
            return
        }

        let status = AVCaptureDevice.authorizationStatus(for: .video)

        switch status {
        case .authorized:
            activeImagePickerSource = .camera
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    guard let self else { return }

                    if granted {
                        self.activeImagePickerSource = .camera
                    } else {
                        self.presentPermissionAlert(
                            message: "Allow camera access to take a profile picture.",
                            offerSettingsRedirect: true
                        )
                    }
                }
            }
        case .denied, .restricted:
            presentPermissionAlert(
                message: "Camera access is disabled. You can enable it in Settings.",
                offerSettingsRedirect: true
            )
        default:
            presentPermissionAlert(
                message: "Camera access is unavailable right now.",
                offerSettingsRedirect: false
            )
        }
    }

    func updateProfileImage(_ image: UIImage) {
        profileImage = image

        Task {
            do {
                isProfileSyncInProgress = true
                let token = try requireToken()
                guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                    throw APIError.invalidRequest
                }
                let profile = try await userService.changeAvatar(token: token, imageData: imageData)
                applyProfile(profile)
            } catch let error as APIErrorResponse {
                presentPermissionAlert(message: error.errorMessage, offerSettingsRedirect: false)
            } catch {
                presentPermissionAlert(
                    message: "Could not update profile image. Please try again.",
                    offerSettingsRedirect: false
                )
            }
            isProfileSyncInProgress = false
        }
    }

    func dismissImagePicker() {
        activeImagePickerSource = nil
    }

    func dismissPermissionAlert() {
        isPermissionAlertPresented = false
        permissionAlertMessage = ""
        shouldOfferSettingsRedirect = false
    }

    func openAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingsURL)
        dismissPermissionAlert()
    }

    private func presentPermissionAlert(message: String, offerSettingsRedirect: Bool) {
        permissionAlertMessage = message
        shouldOfferSettingsRedirect = offerSettingsRedirect
        isPermissionAlertPresented = true
    }

    private func loadCurrentUserProfile() async {
        do {
            isProfileSyncInProgress = true
            let profile: UserService.UserProfileResponse
            if let token = tokenStore.token(), !token.isEmpty {
                profile = try await userService.getCurrentUser(token: token)
            } else if let userId = currentUserID {
                profile = try await userService.getUser(id: userId)
            } else {
                isProfileSyncInProgress = false
                return
            }
            applyProfile(profile)
        } catch {
            // Ignore loading errors silently on launch to keep screen usable offline.
        }

        isProfileSyncInProgress = false
    }

    private func applyProfile(_ profile: UserService.UserProfileResponse) {
        username = profile.username
        bio = profile.bio
        if let id = profile.id {
            UserDefaults.standard.set(id.uuidString, forKey: "userId")
        }
        UserDefaults.standard.set(profile.email, forKey: "userEmail")

        if let avatarURL = profile.avatar {
            Task {
                await loadAvatarImage(from: avatarURL)
            }
        } else {
            profileImage = nil
        }
    }

    private func loadAvatarImage(from rawURL: String) async {
        guard let data = await imageLoaderService.loadImageData(from: rawURL),
              let image = UIImage(data: data)
        else {
            return
        }

        profileImage = image
    }

    private var currentUserID: UUID? {
        guard let storedID = UserDefaults.standard.string(forKey: "userId") else {
            return nil
        }
        return UUID(uuidString: storedID)
    }

    private func requireToken() throws -> String {
        guard let token = tokenStore.token(), !token.isEmpty else {
            throw APIError.invalidRequest
        }
        return token
    }
}
