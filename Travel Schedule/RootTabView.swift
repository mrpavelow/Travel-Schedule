import SwiftUI

struct RootTabView: View {
    init() {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.shadowColor = UIColor.separator
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    
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
