import Foundation

actor NetworkClient {
    
    static let shared = NetworkClient(apiKey: APIConfig.apiKey)
    
    private let apiKey: String
    private var client: Client?
    
    init(apiKey: String) {
        self.apiKey = apiKey
        self.client = nil
    }
    
    // MARK: - Client
    
    private func getClient() throws -> Client {
        if let client { return client }
        let created = try APIConfig.makeClient()
        client = created
        return created
    }
    
    // MARK: - API
    
    func stationsList() async throws -> StationsListDTO {
        let client = try getClient()
        let service = StationsListService(client: client, apikey: apiKey)
        return try await service.getDTO()
    }
    
    func scheduleBetweenStations(
        from: String,
        to: String,
        date: String?
    ) async throws -> Components.Schemas.ScheduleBetweenStationsResponse {
        let client = try getClient()
        let service = ScheduleBetweenStationsService(client: client, apikey: apiKey)
        return try await service.get(from: from, to: to, date: date)
    }
    
    func carrier(code: String, system: String?) async throws -> Components.Schemas.Carrier {
        let client = try getClient()
        let service = CarrierService(client: client, apikey: apiKey)
        return try await service.get(code: code, system: system)
    }
    
    func scheduleOnStation(
        station: String,
        date: String?
    ) async throws -> Components.Schemas.StationScheduleResponse {
        let client = try getClient()
        let service = StationScheduleService(client: client, apikey: apiKey)
        return try await service.get(station: station, date: date)
    }
    
    func threadStations(
        uid: String,
        date: String?
    ) async throws -> Components.Schemas.ThreadResponse {
        let client = try getClient()
        let service = ThreadStationsService(client: client, apikey: apiKey)
        return try await service.get(uid: uid, date: date)
    }
    
    func nearestSettlement(
        lat: Double,
        lng: Double,
        distance: Int?
    ) async throws -> Components.Schemas.NearestSettlementResponse {
        let client = try getClient()
        let service = NearestSettlementService(client: client, apikey: apiKey)
        return try await service.get(lat: lat, lng: lng, distance: distance)
    }
    
    func nearestStations(
        lat: Double,
        lng: Double,
        distance: Int
    ) async throws -> Components.Schemas.Stations {
        let client = try getClient()
        let service = NearestStationsService(client: client, apikey: apiKey)
        return try await service.getNearestStations(lat: lat, lng: lng, distance: distance)
    }
    
    func copyright() async throws -> Components.Schemas.CopyrightResponse {
        let client = try getClient()
        let service = CopyrightService(client: client, apikey: apiKey)
        return try await service.get()
    }
}
