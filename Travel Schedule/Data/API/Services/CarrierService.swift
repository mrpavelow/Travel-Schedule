import OpenAPIRuntime
import OpenAPIURLSession

typealias CarrierResponse = Components.Schemas.CarrierResponse

protocol CarrierServiceProtocol {
    func get(code: String, system: String?) async throws -> CarrierResponse
}

final class CarrierService: CarrierServiceProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func get(code: String, system: String?) async throws -> CarrierResponse {
        let response = try await client.getCarrier(query: .init(
            apikey: apikey,
            code: code,
            format: .json,
            lang: "ru_RU",
            system: system
        ))
        return try response.ok.body.json
    }
}
