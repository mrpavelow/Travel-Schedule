import Foundation

@MainActor
final class CityPickerViewModel: ObservableObject {
    @Published var query: String = ""
    @Published private(set) var cities: [City] = []
    
    private let service = ServicesContainer.shared.stationsListService
    
    func load() async {
        do {
            cities = try await StationsRepository.shared.cities(query: query)
        } catch {
            print("❌ City load error: \(error)")
            cities = []
        }
    }
    
    func refreshFiltered() async {
        do {
            cities = try await StationsRepository.shared.cities(query: query)
        } catch {
            cities = []
        }
    }
}
