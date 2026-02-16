import SwiftUI

struct SettingsView: View {
    @StateObject private var vm = SettingsViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.ypWhiteU).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        SettingsSwitchRow(title: "Темная тема", isOn: $vm.isDarkThemeOverride)
                        
                        Button {
                            vm.openAgreement()
                        } label: {
                            SettingsChevronRow(title: "Пользовательское соглашение")
                        }
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 10) {
                        Text(vm.apiNoteText)
                            .font(.system(size: 13, weight: .regular))
                            .foregroundStyle(Color(.ypBlackU))
                        
                        Text(vm.versionText)
                            .font(.system(size: 13, weight: .regular))
                            .foregroundStyle(Color(.ypBlackU))
                    }
                    .padding(.bottom, 24)
                }
                .padding(.top, 24)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .preferredColorScheme(vm.isDarkThemeOverride ? .dark : .light)
        .sheet(isPresented: $vm.isAgreementPresented) {
            NavigationStack {
                AgreementView()
            }
        }
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
