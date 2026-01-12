import OpenAPIRuntime
import OpenAPIURLSession

typealias ThreadResponse = Components.Schemas.ThreadResponse

protocol ThreadStationsServiceProtocol {
    func get(uid: String, date: String?) async throws -> ThreadResponse
}

final class ThreadStationsService: ThreadStationsServiceProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func get(uid: String, date: String?) async throws -> ThreadResponse {
        let response = try await client.getThreadStations(query: .init(
            apikey: apikey,
            uid: uid,
            format: .json,
            lang: "ru_RU",
            date: date
        ))
        return try response.ok.body.json
    }
}
