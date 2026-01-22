import Foundation

@MainActor
func runHandled<T>(
    _ operation: @escaping () async throws -> T,
    onSuccess: @escaping (T) -> Void,
    onError: (() -> Void)? = nil
) {
    Task {
        do {
            let value = try await operation()
            onSuccess(value)
        } catch {
            onError?()

            
            switch ErrorClassifier.classify(error) {
            case .noInternet:
                GlobalErrorState.shared.show(.noInternet)
            case .serverError:
                GlobalErrorState.shared.show(.serverError)
            case .clientErrorNoOverlay:
                break
            }
        }
    }
}
