import OpenAPIRuntime
import OpenAPIURLSession

typealias ScheduleBetweenStations = Components.Schemas.ScheduleBetweenStationsResponse

protocol ScheduleBetweenStationsServiceProtocol {
    func get(from: String, to: String, date: String?) async throws -> ScheduleBetweenStations
}

final class ScheduleBetweenStationsService: ScheduleBetweenStationsServiceProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func get(from: String, to: String, date: String?) async throws -> ScheduleBetweenStations {
        let response = try await client.getScheduleBetweenStations(query: .init(
            apikey: apikey,
            from: from,
            to: to,
            format: .json,
            lang: "ru_RU",
            date: date
        ))
        return try response.ok.body.json
    }
}
