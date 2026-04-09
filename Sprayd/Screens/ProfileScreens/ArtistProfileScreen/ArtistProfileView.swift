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
        Text("Works")
            .frame(maxWidth: 150)
            .font(.ClimateCrisis20)
    }
    
    private var worksView: some View {
        VStack {
            ForEach(viewModel.works) { work in
                ArtMediumCardView(item: work)
            }
        }
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color.appBackground
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
