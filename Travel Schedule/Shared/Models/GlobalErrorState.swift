import SwiftUI

@MainActor
final class GlobalErrorState: ObservableObject {
    static let shared = GlobalErrorState()
    @Published var kind: ErrorScreenKind?

    func show(_ kind: ErrorScreenKind) { self.kind = kind }
    func dismiss() { kind = nil }
}
