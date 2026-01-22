import Foundation

@MainActor
final class StationPickerViewModel: ObservableObject {
    @Published var query: String = ""
    @Published private(set) var stations: [Station] = []
    
    private let service = ServicesContainer.shared.stationsListService
    
    func loadStations(for city: City) {
        runHandled(
            { try await StationsRepository.shared.stations(in: city, query: self.query) },
            onSuccess: { [weak self] in self?.stations = $0 },
            onError: { [weak self] in self?.stations = [] }
        )
    }

    func refreshFiltered(for city: City) {
        runHandled(
            { try await StationsRepository.shared.stations(in: city, query: self.query) },
            onSuccess: { [weak self] in self?.stations = $0 },
            onError: { [weak self] in self?.stations = [] }
        )
    }
}
