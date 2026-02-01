import SwiftUI

struct MainFlowView: View {
    @State private var path: [Route] = []
    @State private var modalPath: [ModalRoute] = []
    
    @StateObject private var vm = MainFlowViewModel()
    
    var body: some View {
        NavigationStack(path: $path) {
            MainView(
                fromCity: vm.fromCity,
                toCity: vm.toCity,
                fromStation: vm.fromStation,
                toStation: vm.toStation,
                onTapFrom: {
                    modalPath = []
                    vm.openPicker(.from)
                },
                onTapTo: {
                    modalPath = []
                    vm.openPicker(.to)
                },
                onSwap: vm.swapFromTo,
                onFind: { path.append(.carriers) },
                onOpenFilters: { path.append(.filters) }
            )
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .carriers:
                    CarriersListView(
                        fromTitle: vm.fromTitle,
                        toTitle: vm.toTitle,
                        fromCode: vm.fromCode,
                        toCode: vm.toCode,
                        filters: vm.filters,
                        onOpenFilters: { path.append(.filters) },
                        onOpenCarrierCard: { code, system in
                            path.append(.carrierCard(code: code, system: system))
                        }
                    )
                    .toolbar(.hidden, for: .tabBar)
                    
                case .filters:
                    FiltersView(state: $vm.filters, onApply: { vm.applyFilters($0) })
                        .toolbar(.hidden, for: .tabBar)
                    
                case .carrierCard(let code, let system):
                    CarrierCardScreen(code: code, system: system)
                        .toolbar(.hidden, for: .tabBar)
                }
            }
        }
        .fullScreenCover(isPresented: $vm.isPickerPresented) {
            NavigationStack(path: $modalPath) {
                CityPickerView(
                    title: vm.pickingDirection == .from ? "Откуда" : "Куда",
                    onClose: {
                        modalPath = []
                        vm.closePicker()
                    },
                    onSelect: { city in
                        vm.applySelectedCity(city)
                        modalPath = [.stationPicker(city: city)]
                    }
                )
                .navigationDestination(for: ModalRoute.self) { route in
                    switch route {
                    case .stationPicker(let city):
                        StationPickerView(
                            city: city,
                            onSelect: { station in
                                vm.applySelectedStation(station)
                                modalPath = []
                                vm.closePicker()
                            }
                        )
                    }
                }
            }
        }
        .task {
            await StationsRepository.shared.preload()
        }
    }
    
    // MARK: - Modal routes
    
    enum ModalRoute: Hashable {
        case stationPicker(city: City)
    }
    
    enum Route: Hashable {
        case carriers
        case filters
        case carrierCard(code: String, system: String?)
    }
}
