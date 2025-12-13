import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias StationsListResponse = Components.Schemas.StationsListResponse

protocol StationsListServiceProtocol {
    func get() async throws -> StationsListResponse
}

final class StationsListService: StationsListServiceProtocol {
    private let client: Client
    private let apikey: String

    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }

    func get() async throws -> StationsListResponse {
        let response = try await client.getStationsList(query: .init(
            apikey: apikey,
            format: .json,
            lang: "ru_RU"
        ))

        let body = try response.ok.body.html

        let limit = 50 * 1024 * 1024
        let data = try await Data(collecting: body, upTo: limit)

        return try JSONDecoder().decode(StationsListResponse.self, from: data)
    }
}
