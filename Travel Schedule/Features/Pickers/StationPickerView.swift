import SwiftUI

struct StationPickerView: View {
    let city: City
    let onSelect: (Station) -> Void
    
    @StateObject private var vm = StationPickerViewModel()
    
    var body: some View {
        ZStack {
            Color(.ypWhiteU).ignoresSafeArea()
            
            Group {
                if let error = vm.errorText {
                    ContentUnavailableView(
                        "Не удалось загрузить",
                        systemImage: "wifi.exclamationmark",
                        description: Text(error)
                    )
                    
                } else if vm.isEmpty {
                    ContentUnavailableView(
                        "Ничего не найдено",
                        systemImage: "magnifyingglass",
                        description: Text("Попробуйте изменить запрос.")
                    )
                    
                } else {
                    List {
                        ForEach(vm.stations) { station in
                            Button {
                                onSelect(station)
                            } label: {
                                StationRow(title: station.title)
                            }
                            .buttonStyle(.plain)
                            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .listRowBackground(Color(.ypWhiteU))
                            .listRowSeparator(.hidden)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            
            if isEmptySearchResult {
                EmptyStationSearchView()
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isEmptySearchResult)
        .navigationTitle("Выбор станции")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $vm.query, prompt: "Введите запрос")
        .task(id: city.title) {
            await vm.load(for: city)
        }
        .onChange(of: vm.query) {
            vm.applyFilter()
        }
        .toolbar {
            if vm.errorText != nil {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Повторить") {
                        Task { await vm.load(for: city) }
                    }
                }
            }
        }
        .overlay {
            if vm.isLoading {
                ProgressView()
            }
        }
    }
    
    private var isEmptySearchResult: Bool {
        !vm.query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        && vm.stations.isEmpty
    }
}

private struct StationRow: View {
    let title: String
    
    var body: some View {
        HStack(spacing: 0) {
            Text(title)
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(Color(.ypBlackU))
                .padding(.leading, 16)
                .padding(.vertical, 19)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Color(.ypGray))
                .padding(.trailing, 16)
        }
        .frame(height: 60)
        .contentShape(Rectangle())
    }
}

private struct EmptyStationSearchView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Text("Вариантов нет")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color(.ypBlackU))
            
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}
