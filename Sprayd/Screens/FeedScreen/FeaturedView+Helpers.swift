import SwiftUI

extension FeaturedView {
    func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.ClimateCrisis22)
            .foregroundStyle(Color.appPrimaryText)
    }

    func featuredCard(item: ArtItem) -> some View {
        VStack(alignment: .leading, spacing: Metrics.oneAndHalfModule) {
            artworkImage(for: item, height: FeaturedView.Layout.featuredImageHeight)

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: Metrics.module) {
                    Text(item.name)
                        .font(.InstrumentBold20)
                        .foregroundStyle(Color.appPrimaryText)

                    HStack(spacing: Metrics.module) {
                        Circle()
                            .fill(Color.appMutedFill)
                            .frame(width: 24, height: 24)
                            .overlay {
                                Icons.person
                                    .font(.system(size: 8))
                            }

                        Text(item.author)
                            .font(.InstrumentMedium13)
                            .foregroundStyle(Color.appPrimaryText.opacity(0.8))
                            .lineLimit(1)
                    }

                    if let uploadedBy = uploadedByText(for: item) {
                        personLine(label: "Uploaded by", value: uploadedBy, size: 20, font: .InstrumentMedium13)
                    }

                    dateLine(createdAt: item.createdAt, font: .InstrumentMedium13)
                }

                Spacer()

                favoriteButton(for: item)
                    .padding(.top, Metrics.module)
            }
        }
    }

    func cityCard(title: String, imageURL: URL?) -> some View {
        VStack(alignment: .leading, spacing: Metrics.module) {
            cityImage(url: imageURL)

            HStack(alignment: .top, spacing: Metrics.module) {
                Text(title)
                    .font(.InstrumentBold17)
                    .foregroundStyle(Color.appPrimaryText)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: Metrics.halfModule)

                Icons.chevronRight
                    .font(.system(size: 11, weight: .semibold))
                    .padding(.top, 2)
                    .foregroundStyle(Color.appPrimaryText.opacity(0.75))
            }
            .frame(maxWidth: .infinity, minHeight: 42, alignment: .topLeading)
        }
        .frame(width: 116, alignment: .leading)
    }

    private func cityImage(url: URL?) -> some View {
        RoundedRectangle(cornerRadius: 18, style: .continuous)
            .fill(Color.appMutedFill)
            .frame(maxWidth: .infinity)
            .overlay {
                CachedAsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .empty, .failure:
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(Color.clear)
                            .overlay {
                                Icons.photo
                                    .font(.system(size: 22, weight: .regular))
                                    .foregroundStyle(Color.secondaryColor)
                            }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        .frame(height: 78)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    func favoriteButton(for item: ArtItem) -> some View {
        @Bindable var item = item

        return Button {
            item.toggleFavorite(in: modelContext)
        } label: {
            if item.isFavorite {
                Icons.filledHeart
            } else {
                Icons.heart
            }
        }
        .buttonStyle(.plain)
    }

    var emptyState: some View {
        stateCard(
            title: "Nothing here yet",
            message: "Featured objects will appear here as soon as new works are added."
        )
    }

    func stateCard(title: String, message: String) -> some View {
        VStack(alignment: .leading, spacing: Metrics.module) {
            Text(title)
                .font(.InstrumentBold20)
                .foregroundStyle(Color.appPrimaryText)

            Text(message)
                .font(.InstrumentRegular13)
                .foregroundStyle(Color.secondaryColor)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(Metrics.doubleModule)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.appSurface)
                .stroke(Color.appPrimaryText.opacity(0.14), lineWidth: 1)
        )
    }

    func personLine(label: String, value: String, size: CGFloat, font: Font) -> some View {
        HStack(spacing: Metrics.module) {
            Circle()
                .fill(Color.appMutedFill)
                .frame(width: size, height: size)
                .overlay {
                    Icons.person
                        .font(.system(size: max(7, size / 3)))
                }

            personText(label: label, value: value, font: font)
        }
    }

    func personLine(value: String, size: CGFloat, font: Font) -> some View {
        HStack(spacing: Metrics.module) {
            Circle()
                .fill(Color.appMutedFill)
                .frame(width: size, height: size)
                .overlay {
                    Icons.person
                        .font(.system(size: max(7, size / 3)))
                }

            Text(value)
                .font(font)
                .foregroundStyle(Color.appPrimaryText.opacity(0.8))
                .lineLimit(1)
        }
    }

    func personText(label: String, value: String, font: Font) -> some View {
        Text("\(label): \(value)")
            .font(font)
            .foregroundStyle(Color.appPrimaryText.opacity(0.8))
            .lineLimit(1)
    }

    func metadataLine<Icon: View>(text: String, icon: Icon, font: Font) -> some View {
        HStack(spacing: Metrics.halfModule) {
            icon
                .frame(width: Metrics.oneAndHalfModule, height: Metrics.oneAndHalfModule)

            Text(text)
                .font(font)
                .foregroundStyle(Color.secondaryColor)
        }
    }

    func dateLine(createdAt: Date, font: Font) -> some View {
        Text("Uploaded: \(uploadDateText(for: createdAt))")
            .font(font)
            .foregroundStyle(Color.secondaryColor)
            .lineLimit(1)
    }

    func uploadDateText(for date: Date) -> String {
        date.formatted(date: .numeric, time: .omitted)
    }
}
