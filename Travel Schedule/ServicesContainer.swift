import Foundation

final class ServicesContainer {
    static let shared = ServicesContainer()
    
    let stationsListService: StationsListService
    let scheduleService: ScheduleBetweenStationsService
    
    private init() {
        let client = try! APIConfig.makeClient()
        
        self.stationsListService = StationsListService(
            client: client,
            apikey: APIConfig.apiKey
        )
        
        self.scheduleService = ScheduleBetweenStationsService(
            client: client,
            apikey: APIConfig.apiKey
        )
    }
}
