import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias StationsListResponse = Components.Schemas.StationsListResponse

final class StationsListService {
    private let client: Client
    private let apikey: String
    private let decoder: JSONDecoder

    init(
        client: Client,
        apikey: String,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.client = client
        self.apikey = apikey
        self.decoder = decoder
    }

    func get() async throws -> StationsListResponse {
        let response = try await client.getStationsList(query: .init(
            apikey: apikey,
            format: .json,
            lang: "ru_RU"
        ))

        let body = try response.ok.body.html

        let limit = 200 * 1024 * 1024
        let data = try await Data(collecting: body, upTo: limit)

        return try decoder.decode(StationsListResponse.self, from: data)
    }
}
