import SwiftUI

struct GlobalErrorOverlay: View {
    @ObservedObject private var errors = GlobalErrorState.shared
    @ObservedObject private var network = NetworkMonitor.shared

    var body: some View {
        if !network.isOnline {
            ErrorScreen(kind: .noInternet)
                .ignoresSafeArea()
                .onTapGesture { errors.dismiss() }
                .zIndex(999)
        }
        else if let kind = errors.kind {
            ErrorScreen(kind: kind)
                .ignoresSafeArea()
                .onTapGesture { errors.dismiss() }
                .zIndex(999)
        }
    }
}
