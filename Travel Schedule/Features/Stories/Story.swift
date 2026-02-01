import SwiftUI

struct Story: Identifiable, Equatable {
    let id = UUID()
    let backgroundImageName: String
    let thumbnailImageName: String
    let title: String
    let description: String
    var isViewed: Bool = false
}

extension Story {
    static let story1 = Story(
        backgroundImageName: "story1",
        thumbnailImageName: "story1",
        title: "Text1 Text1 Text1",
        description: "Some text Some text Some text Some text Some text"
    )
    
    static let story2 = Story(
        backgroundImageName: "story2",
        thumbnailImageName: "story2",
        title: "Text2 Text2 Text2",
        description: "Another story description"
    )
    
    static let story3 = Story(
        backgroundImageName: "story3",
        thumbnailImageName: "story3",
        title: "Text3 Text3 Text3",
        description: "Third story description"
    )
    
    static let story4 = Story(
        backgroundImageName: "story4",
        thumbnailImageName: "story4",
        title: "Text4 Text4 Text4",
        description: "Fourth story description"
    )
    
    static let story5 = Story(
        backgroundImageName: "story5",
        thumbnailImageName: "story5",
        title: "Text5 Text5 Text5",
        description: "Fifth story description"
    )
    
    static var all: [Story] {
        [story1, story2, story3, story4, story5]
    }
}
