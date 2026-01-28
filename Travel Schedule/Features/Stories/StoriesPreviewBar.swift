import SwiftUI

struct StoriesPreviewBar: View {
    let stories: [Story]
    let onSelect: (Int) -> Void
    
    private var sorted: [(index: Int, story: Story)] {
        stories.enumerated()
            .sorted { lhs, rhs in
                if lhs.element.isViewed != rhs.element.isViewed {
                    return lhs.element.isViewed == false
                }
                return lhs.offset < rhs.offset
            }
            .map { (index: $0.offset, story: $0.element) }
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(sorted, id: \.story.id) { item in
                    let story = item.story
                    
                    Button {
                        onSelect(item.index)
                    } label: {
                        ZStack(alignment: .bottomLeading) {
                            Image(story.thumbnailImageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 92, height: 140)
                                .clipped()
                            
                            Text(story.title)
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.white)
                                .lineLimit(3)
                                .multilineTextAlignment(.leading)
                                .minimumScaleFactor(0.85)
                                .padding(8)
                        }
                        .frame(width: 92, height: 140)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(
                                    story.isViewed ? Color.white.opacity(0.0) : Color.ypBlue,
                                    lineWidth: 4
                                )
                        )
                        .opacity(story.isViewed ? 0.5 : 1.0)
                    }
                    .buttonStyle(.plain)
                    .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
            }
            .padding(.leading, 16)
            .padding(.vertical, 8)
        }
    }
}
