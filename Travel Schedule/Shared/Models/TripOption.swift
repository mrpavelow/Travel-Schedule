import Foundation

struct TripOption: Identifiable, Hashable {
    let id: String
    
    let carrierTitle: String
    let carrierLogoURL: URL?
    let transferText: String?
    
    let departureTime: String
    let arrivalTime: String
    let durationText: String
    let dateText: String
    
    let carrierCode: String
    let carrierSystem: String?
}
