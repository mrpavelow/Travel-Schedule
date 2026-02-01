import Foundation

struct StationsListDTO: Decodable, Sendable {
    let countries: [CountryDTO]?
}

struct CountryDTO: Decodable, Sendable {
    let title: String?
    let regions: [RegionDTO]?
}

struct RegionDTO: Decodable, Sendable {
    let title: String?
    let settlements: [SettlementDTO]?
}

struct SettlementDTO: Decodable, Sendable {
    let title: String?
    let stations: [StationDTO]?
}

struct StationDTO: Decodable, Sendable {
    let title: String?
    let codes: CodesDTO?
    let transport_type: String?
    let station_type: String?
}

struct CodesDTO: Decodable, Sendable {
    let yandex_code: String?
}
