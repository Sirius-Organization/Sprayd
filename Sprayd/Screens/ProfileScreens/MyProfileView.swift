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
        static let vButtonBottomText: String = "Add new seen art"
        static let postedSectionText: String = "Posted"
        static let visitedSectionText: String = "Visited"
        
        // UI constraint properties
        static let profileImageSize: CGFloat = 160
        static let choosePhotoButtonSize: CGFloat = 40
    }
    
    // MARK: - Fields
    @State private var selectedOption = "Posted"
    private var posts: [ArtItem]?
    let onAddArt: () -> ()
    
    // MARK: - Lifecycle
    init(
            posts: [ArtItem]? = nil,
            onAddArt: @escaping () -> Void
        ) {
            self.posts = posts
            self.onAddArt = onAddArt
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
                    Text("Username")
                        .font(.ClimateCrisisRegular22)
                    Icons.pencil
                }
                .frame(maxWidth: .infinity)
                
                HStack {
                    Text("Description")
                        .font(.InstrumentMedium13)
                    Icons.pencil
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    private var pickerView: some View {
        Picker("", selection: $selectedOption) {
            Text(Const.postedSectionText).tag(Const.postedSectionText)
            Text(Const.visitedSectionText).tag(Const.visitedSectionText)
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
    
    private var sectionTitle: some View {
        Text(selectedOption)
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
    
    // TODO: - Replace with an array of posts
    private var postView: some View = ArtMediumCardView()
    
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
                    
                    if selectedOption == Const.postedSectionText {
                        addButtonView
                    }
                    
                    postView
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

//#Preview {
//    MyProfileView(onArtAdd: {})
//}
