import SwiftUI

struct CityPickerView: View {
    let title: String
    let onClose: () -> Void
    let onSelect: (City) -> Void
    
    @StateObject private var vm = CityPickerViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.ypWhiteU).ignoresSafeArea()
                List {
                    ForEach(vm.cities) { city in
                        Button {
                            onSelect(city)
                        } label: {
                            CityRow(title: city.title)
                        }
                        .buttonStyle(.plain)
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .listRowBackground(Color(.ypWhiteU))
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                
                if isEmptySearchResult {
                    EmptySearchView()
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.2), value: isEmptySearchResult)
            .navigationTitle("Выбор города")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: onClose) {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(Color(.ypBlackU))
                    }
                }
            }
            .searchable(text: $vm.query, prompt: "Введите запрос")
            .task {
                await vm.load()
            }
            .onChange(of: vm.query) {
                vm.applyFilter()
            }
        }
    }
    
    private var isEmptySearchResult: Bool {
        !vm.query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        && vm.cities.isEmpty
    }
}

private struct CityRow: View {
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

private struct EmptySearchView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Text("Город не найден")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color(.ypBlackU))
            
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}
