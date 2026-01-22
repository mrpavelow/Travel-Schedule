import SwiftUI

@main
struct TravelScheduleApp: App {
    init() {
        StationsRepository.shared.preload()
    }
    var body: some Scene {
        WindowGroup {
            RootTabView()
                .overlay { GlobalErrorOverlay() }
        }
    }
}
