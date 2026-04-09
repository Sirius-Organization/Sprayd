import SwiftUI

struct ValidationMessageBubble: View {
    let message: String

    var body: some View {
        HStack(spacing: Metrics.module) {
            Text(message)
                .font(.InstrumentRegular16)
                .foregroundStyle(Color.validationError)
                .multilineTextAlignment(.leading)

            Spacer(minLength: Metrics.module)

            Icons.validationAlert
        }
        .padding(.horizontal, Metrics.doubleModule)
        .padding(.vertical, Metrics.oneAndHalfModule)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(alignment: .bottomLeading) {
            BubbleTail()
                .fill(Color.white)
                .frame(width: 20, height: 14)
                .offset(x: Metrics.doubleModule + 10, y: 11)
        }
        .padding(.bottom, Metrics.doubleModule)
    }
}

private struct BubbleTail: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}
