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
    @State private var selectedOption = "Posted"
    private var posts: [Post]?

    // MARK: - Subviews
    private var bioView: some View {
        VStack {
            Icons.personCircle
                .frame(width: Const.profileImageSize, height: Const.profileImageSize)
            VStack(spacing: Metrics.oneAndHalfModule) {
                HStack {
                    Text("Username")
                        .font(.ClimateCrisisRegular22)
                }
                .frame(maxWidth: .infinity)
                
                HStack {
                    Text("Description")
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
    
    // TODO: - Replace with an array of works
    private var worksView: some View = ArtMediumCardView()
        
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

#Preview {
    ArtistProfileView()
}
