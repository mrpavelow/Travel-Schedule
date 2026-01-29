import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias Carrier = Components.Schemas.Carrier
typealias CarrierResponse = Components.Schemas.CarrierResponse

protocol CarrierServiceProtocol {
    func get(code: String, system: String?) async throws -> Carrier
}

final class CarrierService: CarrierServiceProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func get(code: String, system: String?) async throws -> Carrier {
        let response = try await client.getCarrier(query: .init(
            apikey: apikey,
            code: code,
            format: .json,
            lang: "ru_RU",
            system: system
        ))
        let body = try response.ok.body.json
        
        if let carrier = body.carrier { return carrier }
        
        if let first = body.carriers?.first { return first }
        
        throw NSError(domain: "CarrierService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Empty carrier response"])
    }
}
