import Foundation

@MainActor
final class StationsRepository: ObservableObject {
    static let shared = StationsRepository()
    
    enum LoadState: Equatable {
        case idle
        case loading
        case loaded
        case failed(String)
    }
    
    @Published private(set) var state: LoadState = .idle
    
    private let service: StationsListService
    private var cachedDTO: StationsListDTO?
    private var inFlightTask: Task<StationsListDTO, Error>?
    
    private let allowedTransportTypes: Set<String> = [
        "train", "suburban", "bus", "plane", "water"
    ]
    
    private init() {
        let client = try! APIConfig.makeClient()
        self.service = StationsListService(client: client, apikey: APIConfig.apiKey)
    }
    
    func preload() {
        guard cachedDTO == nil else { return }
        guard inFlightTask == nil else { return }
        
        state = .loading
        let task = Task<StationsListDTO, Error> {
            try await service.getDTO()
        }
        inFlightTask = task
        
        Task {
            do {
                let dto = try await task.value
                cachedDTO = dto
                inFlightTask = nil
                state = .loaded
            } catch {
                inFlightTask = nil
                state = .failed(error.localizedDescription)
            }
        }
    }
    
    func getDTO() async throws -> StationsListDTO {
        if let cachedDTO { return cachedDTO }
        if let inFlightTask { return try await inFlightTask.value }
        
        state = .loading
        let task = Task<StationsListDTO, Error> {
            try await service.getDTO()
        }
        inFlightTask = task
        
        do {
            let dto = try await task.value
            cachedDTO = dto
            inFlightTask = nil
            state = .loaded
            return dto
        } catch {
            inFlightTask = nil
            state = .failed(error.localizedDescription)
            throw error
        }
    }
    
    // MARK: - Public API for UI
    
    func cities(query: String) async throws -> [City] {
        let dto = try await getDTO()
        
        let settlements = (dto.countries ?? [])
            .flatMap { $0.regions ?? [] }
            .flatMap { $0.settlements ?? [] }
        
        var titles = settlements.compactMap { $0.title }
        
        titles = Array(Set(titles)).sorted()
        
        let cities = titles.map { City(title: $0) }
        
        guard !query.isEmpty else { return cities }
        return cities.filter { $0.title.localizedCaseInsensitiveContains(query) }
    }
    
    func stations(in city: City, query: String) async throws -> [Station] {
        let dto = try await getDTO()
        
        let settlements = (dto.countries ?? [])
            .flatMap { $0.regions ?? [] }
            .flatMap { $0.settlements ?? [] }
            .filter { $0.title == city.title }
        
        let stationsDTO = settlements
            .flatMap { $0.stations ?? [] }
            .filter { st in
                guard let code = st.codes?.yandex_code, !code.isEmpty else { return false }
                return true
            }
        
        var stations = stationsDTO.compactMap { st -> Station? in
            guard
                let title = st.title,
                let code = st.codes?.yandex_code,
                !code.isEmpty
            else { return nil }
            
            return Station(
                title: title,
                code: code,
                transportType: st.transport_type,
                stationType: st.station_type
            )
        }
        
        var seen = Set<String>()
        stations = stations.filter { seen.insert($0.code).inserted }
        
        stations.sort { $0.title < $1.title }
        
        guard !query.isEmpty else { return stations }
        return stations.filter { $0.title.localizedCaseInsensitiveContains(query) }
    }
}
