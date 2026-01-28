import SwiftUI
import Combine

struct ContentView: View {
    @Binding var isPresented: Bool
    @Binding var stories: [Story]
    @State private var currentStoryIndex: Int

    @State private var progress: CGFloat = 0

    private let storyDuration: TimeInterval = 5
    private let tick: TimeInterval = 0.02
    @State private var timer: Timer.TimerPublisher = Timer.publish(every: 0.02, on: .main, in: .common)
    @State private var cancellable: Cancellable?

    init(
        isPresented: Binding<Bool>,
        stories: Binding<[Story]>,
        startIndex: Int
    ) {
        self._isPresented = isPresented
        self._stories = stories
        self._currentStoryIndex = State(initialValue: startIndex)
    }

    private var currentStory: Story { stories[currentStoryIndex] }

    var body: some View {
        ZStack {
            StoryView(story: currentStory)

            VStack {
                VStack(alignment: .trailing) {
                    StoriesProgressBar(
                        segmentsCount: stories.count,
                        currentIndex: currentStoryIndex,
                        currentProgress: progress
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
        .onAppear { startTimer() }
        .onDisappear { cancellable?.cancel() }
        .onReceive(timer) { _ in onTick() }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onEnded { value in
                    let screenWidth = UIScreen.main.bounds.width

                    if value.translation == .zero {
                        markCurrentStoryViewed()

                        if value.location.x < screenWidth / 2 {
                            previousStory()
                        } else {
                            nextStory()
                        }
                        resetTimerAndProgress()
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

    private func startTimer() {
        timer = Timer.publish(every: tick, on: .main, in: .common)
        cancellable = timer.connect()
    }

    private func onTick() {
        let step = CGFloat(tick / storyDuration)
        let newValue = min(1, progress + step)
        progress = newValue

        if newValue >= 1 {
            markCurrentStoryViewed()
            nextStory()
            resetTimerAndProgress()
        }
    }

    private func nextStory() {
        let nextIndex = currentStoryIndex + 1
        if nextIndex < stories.count {
            currentStoryIndex = nextIndex
        } else {
            currentStoryIndex = 0
        }
    }

    private func previousStory() {
        let prevIndex = currentStoryIndex - 1
        if prevIndex >= 0 {
            currentStoryIndex = prevIndex
        } else {
            currentStoryIndex = stories.count - 1
        }
    }

    private func resetTimerAndProgress() {
        progress = 0
        cancellable?.cancel()
        startTimer()
    }

    private func markCurrentStoryViewed() {
        guard stories.indices.contains(currentStoryIndex) else { return }
        if stories[currentStoryIndex].isViewed == false {
            stories[currentStoryIndex].isViewed = true
        }
    }
}
