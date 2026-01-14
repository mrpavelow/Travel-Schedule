import SwiftUI

struct FiltersView: View {
    @Binding var state: FiltersState
    let onApply: (FiltersState) -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color(.ypWhiteU).ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        
                        sectionTitle("Время отправления")
                            .padding(.top, 8)
                        
                        VStack(spacing: 0) {
                            ForEach(FiltersState.DepartureSlot.allCases) { slot in
                                CheckRow(
                                    title: slot.title,
                                    isChecked: state.selectedSlots.contains(slot),
                                    onTap: { toggle(slot) }
                                )
                                .frame(height: 60)
                            }
                        }
                        
                        sectionTitle("Показывать варианты с\nпересадками")
                            .padding(.top, 24)
                        
                        VStack(spacing: 0) {
                            ForEach(FiltersState.Transfers.allCases) { value in
                                RadioRow(
                                    title: value.title,
                                    isSelected: state.transfers == value,
                                    onTap: { state.transfers = value }
                                )
                                .frame(height: 60)
                            }
                        }
                        
                        Spacer(minLength: 120)
                    }
                    .padding(.horizontal, 16)
                }
                
                Button(action: apply) {
                    Text("Применить")
                        .font(.system(size: 17, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color(.ypBlue))
                        .foregroundStyle(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { dismiss() } label: {
                }
            }
        }
    }
    
    private func sectionTitle(_ s: String) -> some View {
        Text(s)
            .font(.system(size: 24, weight: .bold))
            .foregroundStyle(Color(.ypBlackU))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 12)
    }
    
    private func toggle(_ slot: FiltersState.DepartureSlot) {
        if state.selectedSlots.contains(slot) {
            state.selectedSlots.remove(slot)
        } else {
            state.selectedSlots.insert(slot)
        }
    }
    
    private func apply() {
        onApply(state)
        dismiss()
    }
}
