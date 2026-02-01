import Foundation

struct City: Identifiable, Hashable, Sendable {
    let id = UUID()
    let title: String
}

struct Station: Identifiable, Hashable, Sendable {
    let id = UUID()
    let title: String
    let code: String
    let transportType: String?
    let stationType: String?
}
