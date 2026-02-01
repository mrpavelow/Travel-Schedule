import Foundation

@MainActor
final class StationPickerViewModel: ObservableObject {
    
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorText: String? = nil
    @Published private(set) var isEmpty: Bool = false
    
    @Published var query: String = ""
    @Published private(set) var stations: [Station] = []
    
    private var allStations: [Station] = []
    private var loadedCityTitle: String? = nil
    
    func load(for city: City) async {
        if loadedCityTitle == city.title, !allStations.isEmpty {
            errorText = nil
            applyFilter()
            return
        }
        
        loadedCityTitle = city.title
        allStations = []
        stations = []
        
        isLoading = true
        errorText = nil
        isEmpty = false
        defer { isLoading = false }
        
        do {
            allStations = try await StationsRepository.shared.stations(in: city, query: "")
            applyFilter()
        } catch {
            allStations = []
            stations = []
            isEmpty = true
            errorText = error.localizedDescription
        }
    }
    
    func applyFilter() {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else {
            stations = allStations
            isEmpty = stations.isEmpty
            return
        }
        
        stations = allStations.filter { $0.title.localizedCaseInsensitiveContains(q) }
        isEmpty = stations.isEmpty
    }
}
