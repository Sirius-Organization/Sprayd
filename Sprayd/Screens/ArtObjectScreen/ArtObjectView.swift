//
//  ArtObjectView.swift
//  Sprayd
//
//  Created by лизо4ка курунок on 01.04.2026.
//

import SwiftUI

struct ArtObjectView: View {
    @State private var viewModel = ArtObjectViewModel.sample

    var body: some View {
        @Bindable var viewModel = viewModel

        NavigationStack {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea(edges: .all)
                ScrollView {
                    Spacer(minLength: Metrics.twoAndHalfModule)
                    ArtCardView(viewModel: self.viewModel)

                    VStack(spacing: Metrics.oneAndHalfModule) {
                        markVisitedButton
                        contributeButton
                    }
                    .padding(.horizontal, Metrics.tenTimesModule)
                    .padding(.top, Metrics.doubleModule)
                }
            }
            .navigationDestination(isPresented: $viewModel.isPhotoPreviewPresented) {
                PhotoView(
                    selectedPhotoIndex: $viewModel.selectedPhotoIndex,
                    photoImageNames: self.viewModel.photoImageNames
                )
            }
        }
    }

    private var markVisitedButton: some View {
        Button {
            viewModel.toggleVisited()
        } label: {
            HStack {
                Text(viewModel.isVisited ? "Marked visited" : "Mark visited")
                    .font(Font.InstrumentMedium16)
                Spacer()
                Icons.checkmark
                    .renderingMode(.template)
                    .foregroundColor(.black)
            }
            .foregroundStyle(viewModel.isVisited ? .white : .primary)
            .padding(.horizontal, Metrics.twoAndHalfModule)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(
                viewModel.isVisited
                    ? AnyShapeStyle(Color.accentRed)
                    : AnyShapeStyle(Color.clear)
            )
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.primary, lineWidth: viewModel.isVisited ? 0 : 1.5)
            )
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.2), value: viewModel.isVisited)
    }

    private var contributeButton: some View {
        Button {
        } label: {
            HStack {
                Text("Contribute")
                    .font(Font.InstrumentMedium16)
                Spacer()
                Icons.camera
            }
            .foregroundStyle(.white)
            .padding(.horizontal, Metrics.twoAndHalfModule)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(Color.black)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ArtObjectView()
}
