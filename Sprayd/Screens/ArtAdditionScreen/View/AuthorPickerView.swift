//
//  AuthorPickerView.swift
//  Sprayd
//
//  Created by loxxy on 08.04.2026.
//

import SwiftUI

struct AuthorPickerView: View {
    // MARK: - Constants
    private enum Const {
        static let title = "Pick author"
        static let closeButtonTitle = "Close"
        static let searchPlaceholder = "Search author"
        static let emptyStateText = "No authors found"
        
        static let rowCornerRadius: CGFloat = 20
    }
    
    // MARK: - Fields
    let viewModel: ArtAdditionViewModel
    
    @Environment(\.dismiss) private var dismiss

    @State private var searchQuery = ""

    let onSelect: (Author) -> Void

    private var filteredAuthors: [Author] {
        let trimmedQuery = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else { return viewModel.availableAuthors }

        return viewModel.availableAuthors.filter {
            $0.name.localizedCaseInsensitiveContains(trimmedQuery)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: Metrics.doubleModule) {
                    SearchBarView(
                        placeholder: Const.searchPlaceholder,
                        text: $searchQuery
                    )

                    if filteredAuthors.isEmpty {
                        emptyState
                    } else {
                        LazyVStack(spacing: Metrics.module) {
                            ForEach(filteredAuthors) { author in
                                authorRow(author)
                            }
                        }
                    }
                }
                .padding(.horizontal, Metrics.doubleModule)
                .padding(.vertical, Metrics.module)
            }
            .background(Color.appBackground)
            .navigationTitle(Const.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(Const.closeButtonTitle) {
                        dismiss()
                    }
                }
            }
        }
    }

    private var emptyState: some View {
        Text(Const.emptyStateText)
            .font(.InstrumentRegular13)
            .foregroundStyle(Color.secondaryColor)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, Metrics.quadrupleModule)
    }

    private func authorRow(_ author: Author) -> some View {
        Button {
            onSelect(author)
            dismiss()
        } label: {
            MiniProfileView(name: author.name)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, Metrics.doubleModule)
                .padding(.vertical, Metrics.oneAndHalfModule)
                .background(
                    RoundedRectangle(cornerRadius: Const.rowCornerRadius, style: .continuous)
                        .fill(Color.white.opacity(0.6))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: Const.rowCornerRadius, style: .continuous)
                        .stroke(Color.black.opacity(0.08), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    AuthorPickerView(
        viewModel: ArtAdditionViewModel(),
        onSelect: { _ in }
    )
}
