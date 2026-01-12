import Foundation
import OpenAPIRuntime

@MainActor
final class CarriersListViewModel: ObservableObject {
    @Published private(set) var items: [TripOption] = []
    
    private var allItems: [TripOption] = []
    @Published private(set) var isLoading = false
    
    // MARK: - Logo cache
    
    private struct CarrierKey: Hashable {
        let system: String
        let code: String
    }
    
    private var logosCache: [CarrierKey: URL] = [:]
    
    private func normalizeLogoURL(_ raw: String?) -> URL? {
        guard var s = raw?.trimmingCharacters(in: .whitespacesAndNewlines),
              !s.isEmpty else { return nil }
        if s.hasPrefix("//") { s = "https:" + s }
        return URL(string: s)
    }
    
    // MARK: - Load
    
    func load(from: String, to: String, filters: FiltersState) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let client = try APIConfig.makeClient()
            
            let service = ScheduleBetweenStationsService(client: client, apikey: APIConfig.apiKey)
            let response = try await service.get(from: from, to: to, date: nil)
            let data = try APIConfig.encoder.encode(response)
            let dto = try APIConfig.decoder.decode(SearchDTO.self, from: data)
            
            let segments = dto.segments ?? []
            
            var mapped: [TripOption] = segments.compactMap { seg in
                let carrierLogo = seg.thread?.carrier?.logo
                let carrierTitle = seg.thread?.carrier?.title ?? "Перевозчик"
                let uid = seg.thread?.uid ?? UUID().uuidString
                
                let departureTime = Self.timeText(seg.departure) ?? "--:--"
                let arrivalTime = Self.timeText(seg.arrival) ?? "--:--"
                let dateText = Self.dayMonthFromDateOnly(seg.start_date) ?? "date nil"
                let durationText = Self.durationText(seg.duration)
                
                let transferText: String? = {
                    guard seg.has_transfers == true else { return nil }
                    if let point = seg.transfer_points?.first?.title, !point.isEmpty {
                        return "С пересадкой в \(point)"
                    }
                    return "С пересадкой"
                }()
                
                let carrierSystem: String? = {
                    if seg.thread?.carrier?.codes?.iata != nil { return "iata" }
                    if seg.thread?.carrier?.codes?.yandex != nil { return "yandex" }
                    if seg.thread?.carrier?.codes?.sirena != nil { return "sirena" }
                    return nil
                }()
                
                let carrierCode: String? = {
                    if let v = seg.thread?.carrier?.codes?.iata { return v }
                    if let v = seg.thread?.carrier?.codes?.yandex { return v }
                    if let v = seg.thread?.carrier?.codes?.sirena { return v }
                    return nil
                }()
                
                return TripOption(
                    id: uid,
                    carrierTitle: carrierTitle,
                    carrierLogoURL: carrierLogo,
                    transferText: transferText,
                    departureTime: departureTime,
                    arrivalTime: arrivalTime,
                    durationText: durationText,
                    dateText: dateText,
                    carrierCode: carrierCode,
                    carrierSystem: carrierSystem
                )
            }
            self.allItems = mapped
            apply(filters: filters)
        } catch {
            print("❌ /search parse error:", error)
            self.allItems = []
            self.items = []
        }
    }
    
    // MARK: - Helpers
    
    func apply(filters: FiltersState) {
        var result = allItems
        
        if let transfers = filters.transfers {
            switch transfers {
            case .yes: result = result.filter { $0.transferText != nil }
            case .no:  result = result.filter { $0.transferText == nil }
            }
        }
        
        if !filters.selectedSlots.isEmpty {
            result = result.filter { option in
                guard let hour = Self.hour(from: option.departureTime) else { return false }
                return filters.selectedSlots.contains { slot in
                    if slot == .night { return hour >= 0 && hour < 6 }
                    if slot == .morning { return hour >= 6 && hour < 12 }
                    if slot == .day { return hour >= 12 && hour < 18 }
                    if slot == .evening { return hour >= 18 && hour < 24 }
                    return false
                }
            }
        }
        
        self.items = result
    }
    
    private static func hour(from hhmm: String) -> Int? {
        let parts = hhmm.split(separator: ":")
        guard parts.count >= 2, let h = Int(parts[0]) else { return nil }
        return h
    }
    
    private static let hmsFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "HH:mm:ss"
        return f
    }()
    
    private static let ymdFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()
    
    private static func dayMonthFromDateOnly(_ ymd: String?) -> String? {
        guard let ymd, let d = ymdFormatter.date(from: ymd) else { return nil }
        return dayMonthFormatter.string(from: d)
    }
    
    private static let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ru_RU")
        f.dateFormat = "HH:mm"
        return f
    }()
    
    private static let dayMonthFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ru_RU")
        f.dateFormat = "d MMMM"
        return f
    }()
    
    private static func timeText(_ value: String?) -> String? {
        guard let value else { return nil }
        if let d = hmsFormatter.date(from: value) {
            return timeFormatter.string(from: d)
        }
        return nil
    }
    
    private static func durationText(_ seconds: Double?) -> String {
        guard let seconds else { return "—" }
        let totalMinutes = Int(seconds) / 60
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        
        if hours > 0 && minutes > 0 { return "\(hours) ч \(minutes) мин" }
        if hours > 0 { return "\(hours) часов" }
        return "\(minutes) мин"
    }
}
