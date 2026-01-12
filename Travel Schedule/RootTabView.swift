import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            MainFlowView()
                .tabItem { Image("Schedule") }
            
            SettingsView()
                .tabItem { Image("Gear") }
        }
        .tint(Color("YPBlackU"))
    }
}
