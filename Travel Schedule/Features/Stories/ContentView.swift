import SwiftUI

struct ContentView: View {
    @Binding var isPresented: Bool
    @Binding var stories: [Story]
    
    @StateObject private var vm: StoriesViewModel
    
    init(
        isPresented: Binding<Bool>,
        stories: Binding<[Story]>,
        startIndex: Int
    ) {
        self._isPresented = isPresented
        self._stories = stories
        self._vm = StateObject(wrappedValue: StoriesViewModel(startIndex: startIndex))
    }
    
    private var currentStory: Story { stories[vm.currentStoryIndex] }
    
    var body: some View {
        ZStack {
            StoryView(story: currentStory)
            
            VStack {
                VStack(alignment: .trailing) {
                    StoriesProgressBar(
                        segmentsCount: stories.count,
                        currentIndex: vm.currentStoryIndex,
                        currentProgress: vm.progress
                    )
                    
                    CloseButton {
                        markCurrentStoryViewed()
                        isPresented = false
                    }
                    .padding(.top, 16)
                    .padding(.trailing, 12)
                }
                .padding(.top, 28)
                Spacer()
            }
        }
        .contentShape(Rectangle())
        .task(id: stories.count) {
            await vm.run(storiesCount: stories.count)
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onEnded { value in
                    let screenWidth = UIScreen.main.bounds.width
                    
                    if value.translation == .zero {
                        markCurrentStoryViewed()
                        
                        if value.location.x < screenWidth / 2 {
                            vm.previous(storiesCount: stories.count)
                        } else {
                            vm.next(storiesCount: stories.count)
                        }
                    }
                }
        )
        .simultaneousGesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.height > 120 &&
                        abs(value.translation.height) > abs(value.translation.width) {
                        markCurrentStoryViewed()
                        isPresented = false
                    }
                }
        )
    }
    
    private func markCurrentStoryViewed() {
        let idx = vm.currentStoryIndex
        guard stories.indices.contains(idx) else { return }
        if stories[idx].isViewed == false {
            stories[idx].isViewed = true
        }
    }
}
