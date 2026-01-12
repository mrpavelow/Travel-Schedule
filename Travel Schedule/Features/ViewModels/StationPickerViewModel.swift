import Foundation

@MainActor
final class StationPickerViewModel: ObservableObject {
    @Published var query: String = ""
    @Published private(set) var stations: [Station] = []
    
    private let service = ServicesContainer.shared.stationsListService
    
    func loadStations(for city: City) async {
        do {
            stations = try await StationsRepository.shared.stations(in: city, query: query)
        } catch {
            print("❌ Station load error: \(error)")
            stations = []
        }
    }
    
    func refreshFiltered(for city: City) async {
        do {
            stations = try await StationsRepository.shared.stations(in: city, query: query)
        } catch {
            stations = []
        }
    }
}
