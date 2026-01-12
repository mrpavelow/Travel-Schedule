import SwiftUI

struct CarriersListView: View {
    let fromTitle: String
    let toTitle: String
    let fromCode: String
    let toCode: String
    
    let filters: FiltersState
    
    let onOpenFilters: () -> Void
    let onOpenCarrierCardPlaceholder: () -> Void
    
    @StateObject private var vm = CarriersListViewModel()
    
    var body: some View {
        ZStack {
            Color("YPWhiteU").ignoresSafeArea()
            
            VStack(spacing: 12) {
                Text("\(fromTitle) → \(toTitle)")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color("YPBlackU"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                
                if vm.isLoading {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else if vm.items.isEmpty {
                    Spacer()
                    Text("Вариантов нет")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(Color("YPBlackU"))
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(vm.items) { item in
                                Button { onOpenCarrierCardPlaceholder() } label: {
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
                        .background(Color("YPBlue"))
                        .foregroundStyle(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
        .task { await vm.load(from: fromCode, to: toCode, filters: filters) }
        .onChange(of: filters) { _, newValue in
            vm.apply(filters: newValue)
        }
        
    }
}
