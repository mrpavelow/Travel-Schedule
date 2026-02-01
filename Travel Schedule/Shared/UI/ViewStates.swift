import Foundation

enum ViewState: Sendable, Equatable {
    case idle
    case loading
    case content
    case empty
    case error(String)
}
