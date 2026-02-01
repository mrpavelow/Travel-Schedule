import Foundation

actor StationsRepository {
    static let shared = StationsRepository()
    
    enum LoadState: Equatable {
        case idle
        case loading
        case loaded
        case failed(String)
    }
    
    private let api = NetworkClient.shared
    
    private var state: LoadState = .idle
    private var cachedDTO: StationsListDTO?
    private var inFlightTask: Task<StationsListDTO, Error>?
    
    private let allowedTransportTypes: Set<String> = [
        "train", "suburban", "bus", "plane", "water"
    ]
    
    private init() {}
    
    // MARK: - State
    
    func getState() -> LoadState {
        state
    }
    
    // MARK: - Preload
    
    func preload() async {
        _ = try? await getDTO()
    }
    
    // MARK: - DTO
    
    func getDTO() async throws -> StationsListDTO {
        if let cachedDTO { return cachedDTO }
        
        if let inFlightTask {
            return try await inFlightTask.value
        }
        
        state = .loading
        
        let task = Task<StationsListDTO, Error> {
            try await api.stationsList()
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
        
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return cities }
        return cities.filter { $0.title.localizedCaseInsensitiveContains(q) }
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
                
                if let t = st.transport_type {
                    return allowedTransportTypes.contains(t)
                }
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
        
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return stations }
        return stations.filter { $0.title.localizedCaseInsensitiveContains(q) }
    }
}
