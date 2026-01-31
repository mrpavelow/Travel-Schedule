import SwiftUI

struct StoriesProgressBar: View {
    let segmentsCount: Int
    let currentIndex: Int
    let currentProgress: CGFloat

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<segmentsCount, id: \.self) { index in
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(Color.ypWhite)

                        Capsule()
                            .fill(Color.ypBlue)
                            .frame(width: geo.size.width * progress(for: index))
                    }
                }
                .frame(height: 6)
            }
        }
        .padding(.horizontal, 16)
    }

    private func progress(for index: Int) -> CGFloat {
        index < currentIndex ? 1 : index > currentIndex ? 0 : currentProgress
    }
}
