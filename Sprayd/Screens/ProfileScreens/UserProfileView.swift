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
    @State private var selectedOption = "Posted"
    private var posts: [ArtItem]?

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
    
    private var pickerView: some View {
        Picker("", selection: $selectedOption) {
            Text(Const.postedSectionText).tag(Const.postedSectionText)
            Text(Const.visitedSectionText).tag(Const.visitedSectionText)
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
    
    private var sectionTitle: some View {
        Text(Const.postedSectionText)
            .frame(maxWidth: 150)
            .font(.ClimateCrisisRegular20)
    }
    
    // TODO: - Replace with an array of posts
    private var postView: some View = ArtMediumCardView()
        
    // MARK: - Body
    var body: some View {
        ZStack {
            Color(Color.appBackground)
                        .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    bioView
                    pickerView
                    sectionTitle
                    postView
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

#Preview {
    UserProfileView()
}
