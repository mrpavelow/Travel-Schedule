import Foundation

struct FiltersState: Equatable {
    enum DepartureSlot: CaseIterable, Identifiable {
        case morning, day, evening, night
        
        var id: String { title }
        
        var title: String {
            switch self {
            case .morning: "Утро 06:00 – 12:00"
            case .day: "День 12:00 – 18:00"
            case .evening: "Вечер 18:00 – 00:00"
            case .night: "Ночь 00:00 – 06:00"
            }
        }
        
        var startHour: Int {
            switch self {
            case .morning: 6
            case .day: 12
            case .evening: 18
            case .night: 0
            }
        }
        
        var endHour: Int {
            switch self {
            case .morning: 12
            case .day: 18
            case .evening: 24
            case .night: 6
            }
        }
    }
    
    enum Transfers: Int, CaseIterable, Identifiable {
        case yes = 1
        case no = 0
        
        var id: Int { rawValue }
        
        var title: String {
            switch self {
            case .yes: "Да"
            case .no: "Нет"
            }
        }
    }
    
    var selectedSlots: Set<DepartureSlot> = []
    
    var transfers: Transfers?
}
