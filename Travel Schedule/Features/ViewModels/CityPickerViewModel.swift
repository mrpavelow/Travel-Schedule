import Foundation

@MainActor
final class CityPickerViewModel: ObservableObject {
    @Published var query: String = ""
    @Published private(set) var cities: [City] = []
    
    private let service = ServicesContainer.shared.stationsListService
    
    func load() {
        runHandled(
            { try await StationsRepository.shared.cities(query: self.query) },
            onSuccess: { [weak self] in self?.cities = $0 },
            onError: { [weak self] in self?.cities = [] }
        )
    }

    func refreshFiltered() {
        runHandled(
            { try await StationsRepository.shared.cities(query: self.query) },
            onSuccess: { [weak self] in self?.cities = $0 },
            onError: { [weak self] in self?.cities = [] }
        )
    }
}
