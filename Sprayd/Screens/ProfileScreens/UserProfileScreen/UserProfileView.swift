//
//  UserProfileView.swift
//  Sprayd
//
//  Created by loxxy on 02.04.2026.
//

import SwiftUI

struct UserProfileView: View {
    // MARK: - Constants
    private enum Const {
        // Strings
        static let postedSectionText: String = "Posted"
        static let visitedSectionText: String = "Visited"
        
        // UI constraint properties
        static let profileImageSize: CGFloat = 160
    }
    
    // MARK: - Fields
    @ObservedObject var viewModel: UserProfileViewModel

    // MARK: - Subviews
    private var bioView: some View {
        VStack {
            Icons.personCircle
                .frame(width: Const.profileImageSize, height: Const.profileImageSize)
            VStack(spacing: Metrics.oneAndHalfModule) {
                HStack {
                    Text(viewModel.username)
                        .font(.ClimateCrisis22)
                }
                .frame(maxWidth: .infinity)
                
                HStack {
                    Text(viewModel.bio)
                        .font(.InstrumentMedium13)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    private var sectionTitle: some View {
        Text(Const.postedSectionText)
            .frame(maxWidth: 150)
            .font(.ClimateCrisis20)
    }
        
    private var postsView: some View {
        VStack {
            ForEach(viewModel.posts) { post in
                ArtMediumCardView(
                    title: post.name,
                    location: post.location,
                    description: post.itemDescription,
                    date: "01.01.25",
                    postAuthorName: "PostAuthor",
                    artworkAuthorName: post.author
                )
            }
        }
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color(Color.appBackground)
                        .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    bioView
                    sectionTitle
                    postsView
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

//#Preview {
//    UserProfileView(viewModel: UserProfileViewModel())
//}
