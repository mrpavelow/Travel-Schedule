import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            let client = try! APIConfig.makeClient()
            let carrierService: CarrierServiceProtocol = CarrierService(client: client, apikey: APIConfig.apiKey)
            
            MainFlowView(carrierService: carrierService)
                .tabItem { Image(.schedule) }
            
            SettingsView()
                .tabItem { Image(.gear) }
        }
        .tint(Color(.ypBlackU))
    }
}
