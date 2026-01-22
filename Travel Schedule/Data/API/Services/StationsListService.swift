import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

final class StationsListService {
    private let client: Client
    private let apikey: String
    
    init(
        client: Client,
        apikey: String,
    ) {
        self.client = client
        self.apikey = apikey
    }
    
    func getDTO() async throws -> StationsListDTO {
        let response = try await client.getStationsList(query: .init(
            apikey: apikey,
            format: .json,
            lang: "ru_RU"
        ))
        
        let body = try response.ok.body.html
        
        let limit = 250 * 1024 * 1024
        let data = try await Data(collecting: body, upTo: limit)
        
        return try APIConfig.decoder.decode(StationsListDTO.self, from: data)
    }
}
