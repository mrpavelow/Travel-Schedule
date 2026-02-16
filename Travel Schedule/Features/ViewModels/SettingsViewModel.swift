import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    
    @Published var isDarkThemeOverride: Bool {
        didSet { UserDefaults.standard.set(isDarkThemeOverride, forKey: Keys.darkThemeOverride) }
    }
    
    @Published var isAgreementPresented: Bool = false
    
    let apiNoteText: String = "Приложение использует API «Яндекс.Расписания»"
    let versionText: String = "Версия 1.0 (beta)"
    
    private enum Keys {
        static let darkThemeOverride = "isDarkThemeOverride"
    }
    
    init() {
        self.isDarkThemeOverride = UserDefaults.standard.bool(forKey: Keys.darkThemeOverride)
    }
    
    func openAgreement() {
        isAgreementPresented = true
    }
    
    func closeAgreement() {
        isAgreementPresented = false
    }
}
