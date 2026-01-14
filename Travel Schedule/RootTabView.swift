import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            MainFlowView()
                .tabItem { Image(.schedule) }
            
            SettingsView()
                .tabItem { Image(.gear) }
        }
        .tint(Color(.ypBlackU))
    }
}
