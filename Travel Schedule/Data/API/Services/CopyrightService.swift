import OpenAPIRuntime
import OpenAPIURLSession

typealias CopyrightResponse = Components.Schemas.CopyrightResponse

protocol CopyrightServiceProtocol {
    func get() async throws -> CopyrightResponse
}

final class CopyrightService: CopyrightServiceProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func get() async throws -> CopyrightResponse {
        let response = try await client.getCopyright(query: .init(
            apikey: apikey,
            format: .json
        ))
        return try response.ok.body.json
    }
}
