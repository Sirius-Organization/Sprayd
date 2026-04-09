//
//  ProfileView.swift
//  Sprayd
//
//  Created by Егор Мальцев on 01.04.2026.
//

import SwiftUI
import UIKit
import SwiftData

struct MyProfileView: View {
    // MARK: - Constants
    private enum Const {
        // UI constraint properties
        static let profileImageSize: CGFloat = 160
        static let choosePhotoButtonSize: CGFloat = 40
        static let logoutButtonSize: CGFloat = 40
        static let logoutIconPointSize: CGFloat = 17
        static let editableFieldMaxWidth: CGFloat = 220
        static let profileInfoRowWidth: CGFloat = 260
    }
    
    // MARK: - Fields
    @Query(
        sort: [
            SortDescriptor(\ArtItem.createdAt, order: .reverse),
            SortDescriptor(\ArtItem.name)
        ]
    )
    private var allItems: [ArtItem]

    @ObservedObject var viewModel: MyProfileViewModel
    let onAddArt: () -> Void
    
    // MARK: - Lifecycle
    init(
        onAddArt: @escaping () -> Void,
        viewModel: MyProfileViewModel
    ) {
        self.onAddArt = onAddArt
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            if viewModel.isImageSourceDialogPresented {
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeOut(duration: 0.2)) {
                            viewModel.dismissProfileImageOptions()
                        }
                    }
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: Metrics.doubleModule) {
                    bioView
                    pickerView
                    sectionTitle
                    
                    if viewModel.shouldDisplayAddButton {
                        addButtonView
                    }
                    
                    itemsView
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .task(id: favouriteItemIDs) {
            viewModel.favourites = allItems.filter { $0.isFavorite }
        }
        .sheet(item: $viewModel.activeImagePickerSource) { source in
            ProfileImagePicker(
                source: source,
                onImagePicked: { image in
                    viewModel.updateProfileImage(image)
                    viewModel.dismissImagePicker()
                },
                onCancel: {
                    viewModel.dismissImagePicker()
                }
            )
        }
        .alert("Access Needed", isPresented: $viewModel.isPermissionAlertPresented) {
            if viewModel.shouldOfferSettingsRedirect {
                Button("Settings") {
                    viewModel.openAppSettings()
                }
            }
            
            Button("OK", role: .cancel) {
                viewModel.dismissPermissionAlert()
            }
        } message: {
            Text(viewModel.permissionAlertMessage)
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            HStack {
                Spacer()
                logoutButton
            }
            .padding(.leading, Metrics.tripleModule)
            .padding(.trailing, Metrics.tripleModule)
            .padding(.bottom, Metrics.module)
            .background(Color.appBackground)
        }
        .task {
            viewModel.onAppear()
        }
    }

    private var favouriteItemIDs: [UUID] {
        allItems
            .filter { $0.isFavorite }
            .map { $0.id }
    }
    
    // MARK: - Subviews
    private var bioView: some View {
        VStack() {
            VStack(spacing: Metrics.module) {
                ZStack(alignment: .bottomTrailing) {
                    Group {
                        if let profileImage = viewModel.profileImage {
                            Image(uiImage: profileImage)
                                .resizable()
                                .scaledToFill()
                        } else {
                            Icons.personCircle
                        }
                    }
                    .frame(width: Const.profileImageSize, height: Const.profileImageSize)
                    .clipShape(Circle())
                    
                    Button {
                        withAnimation(.spring(response: 0.28, dampingFraction: 0.82)) {
                            viewModel.presentProfileImageOptions()
                        }
                    } label: {
                        Icons.photo
                            .foregroundStyle(Color.accentRed)
                            .frame(width: Const.choosePhotoButtonSize, height: Const.choosePhotoButtonSize)
                            .background(Color.appContrastBackground)
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                    .offset(x: -Metrics.halfModule, y: -Metrics.halfModule)
                }
                
                if viewModel.isImageSourceDialogPresented {
                    ImageOptionsMenu(
                        choosePhotoLibrary: {
                            viewModel.choosePhotoLibrary()
                        }, chooseCamera: {
                            viewModel.chooseCamera()
                        }
                        
                    )
                        .transition(
                            .asymmetric(
                                insertion: .move(edge: .top).combined(with: .opacity),
                                removal: .opacity
                            )
                        )
                }
            }
            .frame(maxWidth: .infinity)
            
            VStack(spacing: Metrics.oneAndHalfModule) {
                ZStack {
                    if (!viewModel.isEditingUsername) {
                        Text(viewModel.username)
                            .font(.ClimateCrisis22)
                    } else {
                        TextField("Username", text: $viewModel.draftUsername)
                            .font(.ClimateCrisis22)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: Const.editableFieldMaxWidth)
                    }
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            if (viewModel.isEditingUsername) {
                                viewModel.saveUsername()
                            } else {
                                viewModel.enterUsernameEditingMode()
                            }
                        } label: {
                            if (viewModel.isEditingUsername) {
                                Icons.checkmark
                                    .renderingMode(.template)
                                    .foregroundColor(Color.validationSuccess)
                            } else {
                                Icons.pencil
                            }
                        }
                    }
                }
                .frame(width: Const.profileInfoRowWidth)
                
                ZStack {
                    if (!viewModel.isEditingBio) {
                        Text(viewModel.bio)
                            .font(.InstrumentMedium13)
                    } else {
                        TextField("Bio", text: $viewModel.draftBio)
                            .font(.InstrumentMedium13)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: Const.editableFieldMaxWidth)
                    }
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            if (viewModel.isEditingBio) {
                                viewModel.saveBio()
                            } else {
                                viewModel.enterBioEditingMode()
                            }
                        } label: {
                            if (viewModel.isEditingBio) {
                                Icons.checkmark
                                    .renderingMode(.template)
                                    .foregroundColor(Color.validationSuccess)
                            } else {
                                Icons.pencil
                            }
                        }
                    }
                }
                .frame(width: Const.profileInfoRowWidth)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var pickerView: some View {
        Picker("", selection: $viewModel.selectedOption) {
            Text("Posted").tag(MyProfileViewModel.Option.posted)
            Text("Visited").tag(MyProfileViewModel.Option.visited)
            Text("Favourites").tag(MyProfileViewModel.Option.favourites)
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
    
    private var sectionTitle: some View {
        Text(viewModel.selectedOptionTitle)
            .frame(maxWidth: 160)
            .padding(10)
            .font(.ClimateCrisis20)
    }
    
    private var addButtonView: some View {
        VStack(alignment: .center) {
            AddButton(onTap: onAddArt)
            
            Text("Add new seen art")
                .font(.InstrumentMedium13)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var itemsView: some View {
        VStack {
            if let items = viewModel.displayedItems {
                ForEach(items) { item in
                    ArtMediumCardView(item: item)
                }
            }
        }
    }

    private var logoutButton: some View {
        Button {
            viewModel.logout()
        } label: {
            Circle()
                .fill(Color.accentRed)
                .frame(width: Const.logoutButtonSize, height: Const.logoutButtonSize)
                .overlay {
                    if viewModel.isLoggingOut {
                        ProgressView()
                            .tint(Color.appContrastForeground)
                    } else {
                        Icons.logOut
                            .font(.system(size: Const.logoutIconPointSize, weight: .semibold))
                    }
                }
                .shadow(radius: 3)
        }
        .buttonStyle(.plain)
        .disabled(viewModel.isLoggingOut || viewModel.isProfileSyncInProgress)
        .accessibilityLabel("Log out")
    }
}
#Preview {
    MyProfileView(
        onAddArt: {},
        viewModel: MyProfileViewModel(
            authorizationService: AuthorizationService(sender: Sender()),
            userService: UserService(sender: Sender())
        )
    )
}
