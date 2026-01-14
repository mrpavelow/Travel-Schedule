import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkThemeOverride") private var isDarkThemeOverride: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.ypWhiteU).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        SettingsSwitchRow(title: "Темная тема", isOn: $isDarkThemeOverride)
                        Button {
                            //TODO: ссылка на пользовательское соглашение
                        } label: { SettingsChevronRow(title: "Пользовательское соглашение") }
                    }
                    .background(Color(.ypWhiteU))
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    
                    Spacer()
                    
                    VStack(spacing: 10) {
                        Text("Приложение использует API «Яндекс.Расписания»") //Заменить на уведомительный текст из апи (?)
                            .font(.system(size: 13, weight: .regular))
                            .foregroundStyle(Color(.ypBlackU))
                        
                        Text("Версия 1.0 (beta)")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundStyle(Color(.ypBlackU))
                    }
                    .padding(.bottom, 24)
                }
                .padding(.top, 24)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .preferredColorScheme(isDarkThemeOverride ? .dark : nil)
    }
}

private struct SettingsChevronRow: View {
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

private struct SettingsSwitchRow: View {
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            Text(title)
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(Color(.ypBlackU))
                .padding(.leading, 16)
                .padding(.vertical, 19)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .padding(.trailing, 16)
                .tint(Color(.ypBlue))
        }
        .frame(height: 60)
        .contentShape(Rectangle())
    }
}
