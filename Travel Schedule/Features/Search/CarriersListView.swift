import SwiftUI

struct CarriersListView: View {
    let fromTitle: String
    let toTitle: String
    let fromCode: String
    let toCode: String
    
    let filters: FiltersState
    
    let onOpenFilters: () -> Void
    let onOpenCarrierCard: (_ code: String, _ system: String?) -> Void
    
    @StateObject private var vm = CarriersListViewModel()
    
    var body: some View {
        ZStack {
            Color(.ypWhiteU).ignoresSafeArea()
            
            VStack(spacing: 12) {
                Text("\(fromTitle) → \(toTitle)")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color(.ypBlackU))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                
                if let error = vm.errorText {
                    Spacer()
                    ContentUnavailableView(
                        "Не удалось загрузить",
                        systemImage: "wifi.exclamationmark",
                        description: Text(error)
                    )
                    .padding(.horizontal, 16)
                    
                    Button("Повторить") {
                        Task { await vm.load(from: fromCode, to: toCode, filters: filters) }
                    }
                    .font(.system(size: 17, weight: .bold))
                    .padding(.top, 12)
                    
                    Spacer()
                    
                } else if vm.isLoading {
                    Spacer()
                    ProgressView()
                    Spacer()
                    
                } else if vm.isEmpty {
                    Spacer()
                    Text("Вариантов нет")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(Color(.ypBlackU))
                    Spacer()
                    
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            let items = vm.items
                            ForEach(items, id: \.id) { item in
                                Button {
                                    onOpenCarrierCard(item.carrierCode, item.carrierSystem)
                                } label: {
                                    TripCardView(item: item)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 90)
                    }
                }
            }
            
            VStack {
                Spacer()
                Button(action: onOpenFilters) {
                    Text("Уточнить время")
                        .font(.system(size: 17, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color(.ypBlue))
                        .foregroundStyle(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding([.horizontal, .bottom], 16)
            }
        }
        .task(id: "\(fromCode)-\(toCode)") {
            await vm.load(from: fromCode, to: toCode, filters: filters)
        }
        .onChange(of: filters) { _, newValue in
            vm.apply(filters: newValue)
        }
    }
}
