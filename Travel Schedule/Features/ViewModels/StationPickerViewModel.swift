import Foundation

@MainActor
final class StationPickerViewModel: ObservableObject {
    
    @Published private(set) var state: ViewState = .idle
    
    @Published var query: String = ""
    @Published private(set) var stations: [Station] = []
    
    private var allStations: [Station] = []
    private var loadedCityTitle: String? = nil
    
    @MainActor
    func load(for city: City) async {
        if loadedCityTitle == city.title, !allStations.isEmpty {
            state = .idle
            applyFilter()
            return
        }

        loadedCityTitle = city.title
        allStations = []
        stations = []

        state = .loading

        do {
            allStations = try await StationsRepository.shared.stations(in: city, query: "")
            applyFilter()
        } catch {
            allStations = []
            stations = []
            state = .error(error.localizedDescription)
        }
    }
    
    @MainActor
    func applyFilter() {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines)

        if q.isEmpty {
            stations = allStations
        } else {
            stations = allStations.filter { $0.title.localizedCaseInsensitiveContains(q) }
        }

        state = stations.isEmpty ? .empty : .content
    }
}
