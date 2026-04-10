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

    private enum Field: Hashable {
        case username
        case bio
    }
    
    // MARK: - Fields
    @ObservedObject var viewModel: MyProfileViewModel
    let onAddArt: () -> Void
    @FocusState private var focusedField: Field?
    @State private var hasAppeared = false
    
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
                        withAnimation(Motion.quick) {
                            viewModel.dismissProfileImageOptions()
                        }
                    }
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: Metrics.doubleModule) {
                    bioView
                        .entrance(isVisible: hasAppeared, delay: Motion.Delay.section)
                    pickerView
                        .entrance(isVisible: hasAppeared, delay: Motion.Delay.section * 2)
                    sectionTitle
                        .entrance(isVisible: hasAppeared, delay: Motion.Delay.section * 3)
                    
                    if viewModel.shouldDisplayAddButton {
                        addButtonView
                            .transition(.scale(scale: Motion.Scale.subtlePressed).combined(with: .opacity))
                    }
                    
                    itemsSectionView
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .simultaneousGesture(TapGesture().onEnded {
                focusedField = nil
            })
        }
        .toolbar(.hidden, for: .navigationBar)
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
            hasAppeared = true
        }
        .animation(Motion.quick, value: viewModel.shouldDisplayAddButton)
    }

    // MARK: - Subviews
    private var bioView: some View {
        VStack() {
            VStack(spacing: Metrics.module) {
                ZStack(alignment: .bottomTrailing) {
                    avatarView
                    .frame(width: Const.profileImageSize, height: Const.profileImageSize)
                    .clipShape(Circle())
                    
                    Button {
                        withAnimation(Motion.press) {
                            viewModel.presentProfileImageOptions()
                        }
                    } label: {
                        Icons.photo
                            .foregroundStyle(Color.accentRed)
                            .frame(width: Const.choosePhotoButtonSize, height: Const.choosePhotoButtonSize)
                            .background(Color.appContrastBackground)
                            .clipShape(Circle())
                    }
                    .pressScale()
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
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            .frame(maxWidth: Const.editableFieldMaxWidth)
                            .focused($focusedField, equals: .username)
                    }
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            if (viewModel.isEditingUsername) {
                                viewModel.saveUsername()
                                focusedField = nil
                            } else {
                                viewModel.enterUsernameEditingMode()
                                focusedField = .username
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
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            .frame(maxWidth: Const.editableFieldMaxWidth)
                            .focused($focusedField, equals: .bio)
                    }
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            if (viewModel.isEditingBio) {
                                viewModel.saveBio()
                                focusedField = nil
                            } else {
                                viewModel.enterBioEditingMode()
                                focusedField = .bio
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
        Picker("", selection: selectedOptionBinding) {
            Text("Posted").tag(MyProfileViewModel.Option.posted)
            Text("Visited").tag(MyProfileViewModel.Option.visited)
            Text("Favourites").tag(MyProfileViewModel.Option.favourites)
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
        .zIndex(1)
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
        Group {
            switch viewModel.selectedOption {
            case .posted:
                profileItemsList(viewModel.posts)
            case .visited:
                VisitedItemsListView()
            case .favourites:
                FavouriteItemsListView()
            }
        }
    }

    private var itemsSectionView: some View {
        ZStack {
            itemsView
                .id(viewModel.selectedOption)
                .transition(.opacity)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .clipped()
        .zIndex(0)
    }

    private var selectedOptionBinding: Binding<MyProfileViewModel.Option> {
        Binding(
            get: { viewModel.selectedOption },
            set: { newValue in
                guard newValue != viewModel.selectedOption else { return }
                withAnimation(Motion.standard) {
                    viewModel.selectOption(newValue)
                }
            }
        )
    }

    @ViewBuilder
    private var avatarView: some View {
        if let profileImage = viewModel.profileImage {
            Image(uiImage: profileImage)
                .resizable()
                .scaledToFill()
        } else if let profileImageURL = viewModel.profileImageURL {
            CachedAsyncImage(
                url: profileImageURL,
                transaction: Transaction(animation: Motion.quick)
            ) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .empty, .failure:
                    Icons.personCircle
                }
            }
        } else {
            Icons.personCircle
        }
    }

    private func profileItemsList(_ items: [ArtItem]) -> some View {
        LazyVStack(spacing: Metrics.doubleModule) {
            ForEach(items) { item in
                ProfileArtItemCardView(item: item)
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

private struct FavouriteItemsListView: View {
    @Query private var favouriteItems: [ArtItem]

    init() {
        _favouriteItems = Query(
            filter: #Predicate<ArtItem> { $0.isFavorite == true },
            sort: [
                SortDescriptor(\ArtItem.createdAt, order: .reverse),
                SortDescriptor(\ArtItem.name)
            ]
        )
    }

    var body: some View {
        if favouriteItems.isEmpty {
            Text("No favourites yet")
                .font(.InstrumentMedium13)
                .foregroundStyle(Color.secondaryColor)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, Metrics.module)
                .padding(.horizontal, Metrics.tripleModule)
        } else {
            LazyVStack(spacing: Metrics.doubleModule) {
                ForEach(favouriteItems) { item in
                    ProfileArtItemCardView(item: item)
                }
            }
            .padding(.horizontal, Metrics.tripleModule)
        }
    }
}

private struct VisitedItemsListView: View {
    @Query private var visitedItems: [ArtItem]

    init() {
        _visitedItems = Query(
            filter: #Predicate<ArtItem> { $0.isVisited == true },
            sort: [
                SortDescriptor(\ArtItem.createdAt, order: .reverse),
                SortDescriptor(\ArtItem.name)
            ]
        )
    }

    var body: some View {
        if visitedItems.isEmpty {
            Text("No visited items yet")
                .font(.InstrumentMedium13)
                .foregroundStyle(Color.secondaryColor)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, Metrics.module)
                .padding(.horizontal, Metrics.tripleModule)
        } else {
            LazyVStack(spacing: Metrics.doubleModule) {
                ForEach(visitedItems) { item in
                    ProfileArtItemCardView(item: item)
                }
            }
            .padding(.horizontal, Metrics.tripleModule)
        }
    }
}

private struct ProfileArtItemCardView: View {
    private enum Layout {
        static let cornerRadius: CGFloat = 24
        static let imageCornerRadius: CGFloat = 20
        static let imageHeight: CGFloat = 220
    }

    @Environment(\.modelContext) private var modelContext
    let item: ArtItem

    var body: some View {
        VStack(alignment: .leading, spacing: Metrics.oneAndHalfModule) {
            artworkImage

            VStack(alignment: .leading, spacing: Metrics.module) {
                HStack(alignment: .firstTextBaseline, spacing: Metrics.module) {
                    Text(item.name)
                        .font(.InstrumentBold20)
                        .foregroundStyle(Color.appPrimaryText)
                        .lineLimit(2)

                    Spacer(minLength: Metrics.module)

                    Button {
                        withAnimation(Motion.favorite) {
                            item.toggleFavorite(in: modelContext)
                        }
                    } label: {
                        if item.isFavorite {
                            Icons.filledHeart
                        } else {
                            Icons.heart
                        }
                    }
                    .scaleEffect(item.isFavorite ? Motion.Scale.favoriteSelected : Motion.Scale.identity)
                    .animation(Motion.favorite, value: item.isFavorite)
                    .pressScale()
                }

                HStack(alignment: .center, spacing: Metrics.halfModule) {
                    Icons.location

                    Text(item.location)
                        .font(.InstrumentRegular13)
                        .foregroundStyle(Color.secondaryColor)
                        .lineLimit(2)

                    Spacer(minLength: Metrics.module)

                    Text(item.createdAt.formatted(date: .numeric, time: .omitted))
                        .font(.InstrumentRegular13)
                        .foregroundStyle(Color.secondaryColor)
                        .lineLimit(1)
                }

                Text(item.itemDescription)
                    .font(.InstrumentRegular13)
                    .foregroundStyle(Color.secondaryColor)
                    .lineLimit(4)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(Metrics.oneAndHalfModule)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: Layout.cornerRadius, style: .continuous)
                .fill(Color.appSurface)
                .stroke(Color.appPrimaryText.opacity(0.18), lineWidth: 1)
        )
        .entrance(isVisible: true, delay: Motion.Delay.section)
    }

    private var artworkImage: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Layout.imageCornerRadius, style: .continuous)
                .fill(Color.appMutedFill)

            CachedAsyncImage(url: item.primaryImageURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .transition(.opacity)
                case .empty, .failure:
                    Icons.photo
                        .font(.system(size: 32, weight: .regular))
                        .foregroundStyle(Color.secondaryColor)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: Layout.imageHeight)
        .clipShape(RoundedRectangle(cornerRadius: Layout.imageCornerRadius, style: .continuous))
    }
}
