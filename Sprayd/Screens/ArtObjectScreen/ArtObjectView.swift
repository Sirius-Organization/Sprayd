//
//  ArtObjectView.swift
//  Sprayd
//
//  Created by лизо4ка курунок on 01.04.2026.
//

import SwiftUI

struct ArtObjectView: View {
    @State private var isVisited = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea(edges: .all)
                ScrollView {
                    Spacer(minLength: 20)
                    ArtMediumCardView()
                    VStack(spacing: 12) {
                        markVisitedButton
                        contributeButton
                    }
                    .padding(.horizontal, 80)
                    .padding(.top, 16)
                }
            }
        }
    }

    private var markVisitedButton: some View {
        Button {
            isVisited.toggle()
        } label: {
            HStack {
                Text(isVisited ? "Marked visited" : "Mark visited")
                    .font(Font.InstrumentMedium16)
                Spacer()
                Image(systemName: "checkmark")
                    .fontWeight(.medium)
            }
            .foregroundStyle(isVisited ? .white : .primary)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(
                isVisited
                    ? AnyShapeStyle(Color.accentRed)
                    : AnyShapeStyle(Color.clear)
            )
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.primary, lineWidth: isVisited ? 0 : 1.5)
            )
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.2), value: isVisited)
    }

    private var contributeButton: some View {
        Button {
        } label: {
            HStack {
                Text("Contribute")
                    .font(Font.InstrumentMedium16)
                Spacer()
                Image(systemName: "camera")
                    .fontWeight(.medium)
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 20)
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
