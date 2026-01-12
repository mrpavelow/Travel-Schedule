import SwiftUI

enum Direction { case from, to }

struct MainFlowView: View {
    @State private var path: [Route] = []
    
    @State private var fromCity: City?
    @State private var toCity: City?
    @State private var fromStation: Station?
    @State private var toStation: Station?
    @State private var filters = FiltersState()
    
    @State private var isPickerPresented = false
    @State private var pickingDirection: Direction = .from
    @State private var modalPath: [ModalRoute] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            MainView(
                fromCity: fromCity,
                toCity: toCity,
                fromStation: fromStation,
                toStation: toStation,
                onTapFrom: { openPicker(.from) },
                onTapTo: { openPicker(.to) },
                onSwap: swapFromTo,
                onFind: { path.append(.carriers) },
                onOpenFilters: { path.append(.filters) }
            )
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .carriers:
                    CarriersListView(
                        fromTitle: fromStation?.title ?? fromCity?.title ?? "",
                        toTitle: toStation?.title ?? toCity?.title ?? "",
                        fromCode: fromStation?.code ?? "",
                        toCode: toStation?.code ?? "",
                        filters: filters,
                        onOpenFilters: { path.append(.filters) },
                        onOpenCarrierCardPlaceholder: { path.append(.carrierCardPlaceholder) }
                    )
                    .toolbar(.hidden, for: .tabBar)
                    
                case .filters:
                    FiltersView(state: $filters, onApply: { filters = $0 })
                        .toolbar(.hidden, for: .tabBar)
                    
                case .carrierCardPlaceholder:
                    CarrierCardView()
                        .toolbar(.hidden, for: .tabBar)
                }
            }
        }
        .fullScreenCover(isPresented: $isPickerPresented) {
            NavigationStack(path: $modalPath) {
                CityPickerView(
                    title: pickingDirection == .from ? "Откуда" : "Куда",
                    onClose: closePicker,
                    onSelect: { city in
                        applySelectedCity(city)
                        modalPath = [.stationPicker(city: city)]
                    }
                )
                .navigationDestination(for: ModalRoute.self) { route in
                    switch route {
                    case .stationPicker(let city):
                        StationPickerView(
                            city: city,
                            onSelect: { station in
                                applySelectedStation(station)
                                closePicker()
                            }
                        )
                    }
                }
            }
        }
    }
    
    // MARK: - Modal routes
    
    enum ModalRoute: Hashable {
        case stationPicker(city: City)
    }
    
    enum Route: Hashable {
        case carriers
        case filters
        case carrierCardPlaceholder
    }
    
    // MARK: - Actions
    
    private func openPicker(_ dir: Direction) {
        pickingDirection = dir
        modalPath = []
        isPickerPresented = true
    }
    
    private func closePicker() {
        modalPath = []
        isPickerPresented = false
    }
    
    private func applySelectedCity(_ city: City) {
        switch pickingDirection {
        case .from:
            fromCity = city
            fromStation = nil
        case .to:
            toCity = city
            toStation = nil
        }
    }
    
    private func applySelectedStation(_ station: Station) {
        switch pickingDirection {
        case .from:
            fromStation = station
        case .to:
            toStation = station
        }
    }
    
    private func swapFromTo() {
        swap(&fromCity, &toCity)
        swap(&fromStation, &toStation)
    }
}
