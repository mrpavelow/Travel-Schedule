import Foundation

final class ServicesContainer {
    static let shared = ServicesContainer()
    
    let stationsListService: StationsListService
    let scheduleService: ScheduleBetweenStationsService
    
    private init() {
        do {
            let client = try APIConfig.makeClient()
            
            self.stationsListService = StationsListService(
                client: client,
                apikey: APIConfig.apiKey
            )
            
            self.scheduleService = ScheduleBetweenStationsService(
                client: client,
                apikey: APIConfig.apiKey
            )
        } catch {
            fatalError("Failed to create API client: \(error)")
        }
    }
}
