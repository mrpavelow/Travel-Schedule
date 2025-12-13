import OpenAPIRuntime
import OpenAPIURLSession

typealias StationSchedule = Components.Schemas.StationScheduleResponse

protocol StationScheduleServiceProtocol {
  func get(station: String, date: String?) async throws -> StationSchedule
}

final class StationScheduleService: StationScheduleServiceProtocol {
  private let client: Client
  private let apikey: String

  init(client: Client, apikey: String) {
    self.client = client
    self.apikey = apikey
  }

  func get(station: String, date: String?) async throws -> StationSchedule {
    let response = try await client.getScheduleOnStation(query: .init(
      apikey: apikey,
      station: station,
      lang: "ru_RU",
      format: .json,
      date: date
    ))
    return try response.ok.body.json
  }
}
