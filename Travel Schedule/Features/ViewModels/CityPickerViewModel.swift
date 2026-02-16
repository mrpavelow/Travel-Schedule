import Foundation

@MainActor
final class CityPickerViewModel: ObservableObject {
    
    @Published var query: String = ""
    @Published private(set) var cities: [City] = []
    
    private var allCities: [City] = []
    
    func load() async {
        if !allCities.isEmpty {
            applyFilter()
            return
        }
        
        do {
            allCities = try await StationsRepository.shared.cities(query: "")
            applyFilter()
        } catch {
            allCities = []
            cities = []
        }
    }
    
    func applyFilter() {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else {
            cities = allCities
            return
        }
        cities = allCities.filter { $0.title.localizedCaseInsensitiveContains(q) }
    }
}
