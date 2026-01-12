import Foundation

struct FiltersState: Equatable {
    enum DepartureSlot: CaseIterable, Identifiable {
        case morning, day, evening, night

        var id: String { title }

        var title: String {
            switch self {
            case .morning: return "Утро 06:00 – 12:00"
            case .day:     return "День 12:00 – 18:00"
            case .evening: return "Вечер 18:00 – 00:00"
            case .night:   return "Ночь 00:00 – 06:00"
            }
        }

        var startHour: Int {
            switch self {
            case .morning: return 6
            case .day:     return 12
            case .evening: return 18
            case .night:   return 0
            }
        }

        var endHour: Int {
            switch self {
            case .morning: return 12
            case .day:     return 18
            case .evening: return 24
            case .night:   return 6
            }
        }
    }

    enum Transfers: Int, CaseIterable, Identifiable {
        case yes = 1
        case no = 0

        var id: Int { rawValue }

        var title: String {
            switch self {
            case .yes: return "Да"
            case .no:  return "Нет"
            }
        }
    }

    var selectedSlots: Set<DepartureSlot> = []

    var transfers: Transfers? = nil
}
