import SwiftUI

struct StoryView: View {
    let story: Story
    
    var body: some View {
        ZStack {
            Color.ypBlack
                .ignoresSafeArea()
            ZStack(alignment: .bottomLeading) {
                
                Image(story.backgroundImageName)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text(story.title)
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(story.description)
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(.white)
                        .lineLimit(3)
                }
                .padding(.horizontal, 16)
                .safeAreaPadding(.bottom, 40)
            }
            .clipShape(RoundedRectangle(cornerRadius: 40, style: .continuous))
        }
    }
}
