//
//  CategoryPickerView.swift
//  Sprayd
//
//  Created by loxxy on 08.04.2026.
//

import SwiftUI

struct CategoryPickerView: View {
    // MARK: - Constants
    private enum Const {
        static let title = "Pick category"
        static let closeButtonTitle = "Close"
        static let searchPlaceholder = "Search category"
        static let emptyStateText = "No categories found"

        static let rowCornerRadius: CGFloat = 20
    }

    // MARK: - Fields
    let viewModel: ArtAdditionViewModel

    @Environment(\.dismiss) private var dismiss

    @State private var searchQuery = ""

    let onSelect: (Category) -> Void

    private var filteredCategories: [Category] {
        let trimmedQuery = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else { return viewModel.availableCategories }

        return viewModel.availableCategories.filter {
            $0.name.localizedCaseInsensitiveContains(trimmedQuery)
        }
    }

    // MARK: - Body
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: Metrics.doubleModule) {
                    SearchBarView(
                        placeholder: Const.searchPlaceholder,
                        text: $searchQuery
                    )

                    if filteredCategories.isEmpty {
                        emptyState
                    } else {
                        LazyVStack(spacing: Metrics.module) {
                            ForEach(filteredCategories) { category in
                                categoryRow(category)
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

    // MARK: - Subviews
    private var emptyState: some View {
        Text(Const.emptyStateText)
            .font(.InstrumentRegular13)
            .foregroundStyle(Color.secondaryColor)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, Metrics.quadrupleModule)
    }

    private func categoryRow(_ category: Category) -> some View {
        Button {
            onSelect(category)
            dismiss()
        } label: {
            HStack {
                CategoryCapsule(title: category.name)
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, Metrics.doubleModule)
            .padding(.vertical, Metrics.oneAndHalfModule)
            .background(
                RoundedRectangle(cornerRadius: Const.rowCornerRadius, style: .continuous)
                    .fill(Color.appSurface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: Const.rowCornerRadius, style: .continuous)
                    .stroke(Color.appPrimaryText.opacity(0.08), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    Text("CategoryPickerView Preview")
}
