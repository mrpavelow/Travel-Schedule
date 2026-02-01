import Foundation
import SwiftUI

@MainActor
final class StoriesViewModel: ObservableObject {
    
    @Published private(set) var currentStoryIndex: Int
    @Published private(set) var progress: CGFloat = 0
    @Published private(set) var didAutoAdvance = false
    
    private let storyDuration: TimeInterval
    private let tick: TimeInterval
    
    init(startIndex: Int, storyDuration: TimeInterval = 5, tick: TimeInterval = 0.02) {
        self.currentStoryIndex = startIndex
        self.storyDuration = storyDuration
        self.tick = tick
    }
    
    func run(storiesCount: Int) async {
        guard storiesCount > 0 else { return }
        
        while !Task.isCancelled {
            if currentStoryIndex < 0 { currentStoryIndex = 0 }
            if currentStoryIndex >= storiesCount { currentStoryIndex = 0 }
            
            progress = 0
            
            let steps = max(1, Int(storyDuration / tick))
            let stepValue = CGFloat(1.0 / Double(steps))
            
            for _ in 0..<steps {
                if Task.isCancelled { return }
                try? await Task.sleep(for: .seconds(tick))
                progress = min(1, progress + stepValue)
            }
            didAutoAdvance = true
            next(storiesCount: storiesCount)
            didAutoAdvance = false
            next(storiesCount: storiesCount)
        }
    }
    
    func reset() {
        progress = 0
    }
    
    func next(storiesCount: Int) {
        guard storiesCount > 0 else { return }
        currentStoryIndex = (currentStoryIndex + 1) % storiesCount
        progress = 0
    }
    
    func previous(storiesCount: Int) {
        guard storiesCount > 0 else { return }
        currentStoryIndex = (currentStoryIndex - 1 + storiesCount) % storiesCount
        progress = 0
    }
    
    func jump(to index: Int, storiesCount: Int) {
        guard storiesCount > 0 else { return }
        currentStoryIndex = min(max(0, index), storiesCount - 1)
        progress = 0
    }
}
