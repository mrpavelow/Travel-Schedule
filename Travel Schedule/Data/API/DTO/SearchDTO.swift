import Foundation

// MARK: - /search response DTO

struct SearchDTO: Decodable {
    let segments: [SegmentDTO]?
}

struct SegmentDTO: Decodable {
    let departure: String?
    let arrival: String?
    let duration: Double?
    let start_date: String?
    
    let has_transfers: Bool?
    let transfer_points: [TransferPointDTO]?
    
    let thread: ThreadDTO?
}

struct ThreadDTO: Decodable {
    let uid: String?
    let carrier: CarrierDTO?
}

struct CarrierDTO: Decodable {
    let title: String?
    let logo: URL?
    let codes: CarrierCodesDTO?

    let contacts: String?
    let phone: String?
    let email: String?
    let code: Int?
    let address: String?
    let url: URL?
}

struct CarrierCodesDTO: Decodable {
    let iata: String?
    let yandex: String?
    let sirena: String?
}

struct TransferPointDTO: Decodable {
    let title: String?
}
