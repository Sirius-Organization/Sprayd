//
//  ProfileView.swift
//  Sprayd
//
//  Created by Егор Мальцев on 01.04.2026.
//

import SwiftUI

struct MyProfileView: View {
    // MARK: - Constants
    private enum Const {
        // Strings
        static let postedButtonBottomText: String = "Add new seen art"
        static let postedSectionText: String = "Posted"
        static let visitedSectionText: String = "Visited"

        // UI constraint properties
        static let profileImageSize: CGFloat = 160
        static let choosePhotoButtonSize: CGFloat = 40
    }
    
    // MARK: - Fields
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
    
    // MARK: - Subviews
    private var bioView: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                Icons.personCircle
                    .frame(width: Const.profileImageSize, height: Const.profileImageSize)
                
                Button {
                    // TODO: - Open photo choice screen
                } label: {
                    Icons.photo
                        .foregroundStyle(Color.accentRed)
                        .frame(width: Const.choosePhotoButtonSize, height: Const.choosePhotoButtonSize)
                        .background(Color.black)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
                .offset(x: -Metrics.halfModule, y: -Metrics.halfModule)
            }
            .frame(maxWidth: .infinity)
            
            VStack(spacing: Metrics.oneAndHalfModule) {
                HStack {
                    Text(viewModel.username)
                        .font(.ClimateCrisisRegular22)
                    Icons.pencil
                }
                .frame(maxWidth: .infinity)
                
                HStack {
                    Text(viewModel.bio)
                        .font(.InstrumentMedium13)
                    Icons.pencil
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    private var pickerView: some View {
        Picker("", selection: $viewModel.selectedOption) {
            Text(Const.postedSectionText).tag(MyProfileViewModel.Option.posted)
            Text(Const.visitedSectionText).tag(MyProfileViewModel.Option.visited)
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
    
    private var sectionTitle: some View {
        Text(viewModel.selectedOptionTitle)
            .frame(maxWidth: 150)
            .font(.ClimateCrisisRegular20)
    }
    
    private var addButtonView: some View {
        VStack(alignment: .center) {
            AddButton(onTap: onAddArt)
            
            Text(Const.postedButtonBottomText)
                .font(.InstrumentMedium13)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var itemsView: some View {
        VStack {
            if let items = viewModel.displayedItems {
                ForEach(items) { item in
                    ArtMediumCardView()
                }
            }
        }
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color(Color.appBackground)
                .ignoresSafeArea()
            
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
    }
}

//#Preview {
//    MyProfileView(onArtAdd: {})
//}
