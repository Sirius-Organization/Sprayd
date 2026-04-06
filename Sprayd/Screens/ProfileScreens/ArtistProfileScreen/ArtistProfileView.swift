//
//  ArtistProfileView.swift
//  Sprayd
//
//  Created by loxxy on 01.04.2026.
//

import SwiftUI

struct ArtistProfileView: View {
    // MARK: - Constants
    private enum Const {
        // Strings
        static let worksSectionText: String = "Works"
        
        // UI constraint properties
        static let profileImageSize: CGFloat = 160
        static let profileImageCornerRadius: CGFloat = profileImageSize / 2
    }
    
    // MARK: - Fields
    @ObservedObject var viewModel: ArtistProfileViewModel
    
    // MARK: - Subviews
    private var bioView: some View {
        VStack {
            Icons.personCircle
                .frame(width: Const.profileImageSize, height: Const.profileImageSize)
            VStack(spacing: Metrics.oneAndHalfModule) {
                HStack {
                    Text(viewModel.username)
                        .font(.ClimateCrisisRegular22)
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
        Text(Const.worksSectionText)
            .frame(maxWidth: 150)
            .font(.ClimateCrisisRegular20)
    }
    
    private var worksView: some View {
        VStack {
            ForEach(viewModel.works) { work in
                ArtMediumCardView(
                    title: work.name,
                    location: work.location,
                    description: work.itemDescription,
                    date: "01.01.25",
                    postAuthorName: "PostAuthor",
                    artworkAuthorName: work.author
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
                VStack(alignment: .leading, spacing: Metrics.doubleModule) {
                    bioView

                    sectionTitle
                    
                    worksView
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

//#Preview {
//    ArtistProfileView()
//}
