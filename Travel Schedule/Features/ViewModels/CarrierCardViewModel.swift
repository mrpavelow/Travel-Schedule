import Foundation

@MainActor
final class CarrierCardViewModel: ObservableObject {
    @Published private(set) var isLoading = true
    @Published private(set) var errorText: String?
    
    @Published private(set) var title: String = "Перевозчик"
    @Published private(set) var logoURL: URL?
    @Published private(set) var phone: String?
    @Published private(set) var email: String?
    
    private let code: String
    private let system: String?
    
    private let api = NetworkClient.shared
    private var didLoad = false
    
    init(code: String, system: String?) {
        self.code = code
        self.system = system
    }
    
    func loadIfNeeded() async {
        guard !didLoad else { return }
        didLoad = true
        await load()
    }
    
    func reload() async {
        didLoad = false
        await loadIfNeeded()
    }
    
    private func load() async {
        isLoading = true
        errorText = nil
        
        do {
            let carrier = try await api.carrier(code: code, system: system)
            
            title = carrier.title ?? "Перевозчик"
            phone = normalizeEmpty(carrier.phone)
            email = normalizeEmpty(carrier.email)
            logoURL = normalizeLogoURL(carrier.logo)
            
            isLoading = false
        } catch {
            isLoading = false
            errorText = "Не удалось загрузить перевозчика: \(error.localizedDescription)"
        }
    }
    
    private func normalizeEmpty(_ s: String?) -> String? {
        guard let s, !s.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return nil }
        return s
    }
    
    private func normalizeLogoURL(_ raw: String?) -> URL? {
        guard var s = raw?.trimmingCharacters(in: .whitespacesAndNewlines),
              !s.isEmpty else { return nil }
        if s.hasPrefix("//") { s = "https:" + s }
        return URL(string: s)
    }
}
