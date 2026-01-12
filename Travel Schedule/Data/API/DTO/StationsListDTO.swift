import Foundation

struct StationsListDTO: Decodable {
    let countries: [CountryDTO]?
}

struct CountryDTO: Decodable {
    let title: String?
    let regions: [RegionDTO]?
}

struct RegionDTO: Decodable {
    let title: String?
    let settlements: [SettlementDTO]?
}

struct SettlementDTO: Decodable {
    let title: String?
    let stations: [StationDTO]?
}

struct StationDTO: Decodable {
    let title: String?
    let codes: CodesDTO?
    let transport_type: String?
    let station_type: String?
}

struct CodesDTO: Decodable {
    let yandex_code: String?
}
