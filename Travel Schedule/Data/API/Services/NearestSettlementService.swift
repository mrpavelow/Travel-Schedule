import OpenAPIRuntime
import OpenAPIURLSession

typealias NearestSettlement = Components.Schemas.NearestSettlementResponse

protocol NearestSettlementServiceProtocol {
    func get(lat: Double, lng: Double, distance: Int?) async throws -> NearestSettlement
}

final class NearestSettlementService: NearestSettlementServiceProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func get(lat: Double, lng: Double, distance: Int?) async throws -> NearestSettlement {
        let response = try await client.getNearestSettlement(query: .init(
            apikey: apikey,
            lat: lat,
            lng: lng,
            distance: distance,
            lang: "ru_RU",
            format: .json
        ))
        return try response.ok.body.json
    }
}
