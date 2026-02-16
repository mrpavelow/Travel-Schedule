import Foundation

@MainActor
final class MainFlowViewModel: ObservableObject {
    
    enum Direction { case from, to }
    
    @Published var fromCity: City?
    @Published var toCity: City?
    @Published var fromStation: Station?
    @Published var toStation: Station?
    @Published var filters = FiltersState()
    
    @Published var isPickerPresented = false
    @Published var pickingDirection: Direction = .from
    
    // MARK: - Computed for UI
    
    var fromTitle: String { fromStation?.title ?? fromCity?.title ?? "" }
    var toTitle: String { toStation?.title ?? toCity?.title ?? "" }
    
    var fromCode: String { fromStation?.code ?? "" }
    var toCode: String { toStation?.code ?? "" }
    
    // MARK: - Actions
    
    func openPicker(_ dir: Direction) {
        pickingDirection = dir
        isPickerPresented = true
    }
    
    func closePicker() {
        isPickerPresented = false
    }
    
    func applySelectedCity(_ city: City) {
        switch pickingDirection {
        case .from:
            fromCity = city
            fromStation = nil
        case .to:
            toCity = city
            toStation = nil
        }
    }
    
    func applySelectedStation(_ station: Station) {
        switch pickingDirection {
        case .from:
            fromStation = station
        case .to:
            toStation = station
        }
    }
    
    func swapFromTo() {
        swap(&fromCity, &toCity)
        swap(&fromStation, &toStation)
    }
    
    func applyFilters(_ newValue: FiltersState) {
        filters = newValue
    }
}
