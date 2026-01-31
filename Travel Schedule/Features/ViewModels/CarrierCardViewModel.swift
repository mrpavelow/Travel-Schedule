import SwiftUI

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
    private let carrierService: CarrierServiceProtocol
    
    private var didLoad = false
    
    init(code: String, system: String?, carrierService: CarrierServiceProtocol) {
        self.code = code
        self.system = system
        self.carrierService = carrierService
    }
    
    func loadIfNeeded() async {
        guard !didLoad else { return }
        didLoad = true
        await load()
    }
    
    func reload() {
        didLoad = false
        isLoading = true
        errorText = nil
        Task { await loadIfNeeded() }
    }
    
    private func load() async {
        isLoading = true
        errorText = nil
        
        do {
            let carrier = try await carrierService.get(code: code, system: system)
            
            title = carrier.title ?? "Перевозчик"
            phone = normalizeEmpty(carrier.phone)
            email = normalizeEmpty(carrier.email)
            
            if let logoStr = carrier.logo, !logoStr.isEmpty {
                let fixed = logoStr.hasPrefix("//") ? "https:\(logoStr)" : logoStr
                logoURL = URL(string: fixed)
            } else {
                logoURL = nil
            }
            
            isLoading = false
        } catch {
            isLoading = false
            let msg = (error as NSError).localizedDescription
            errorText = "Не удалось загрузить перевозчика: \(msg)"
            print("Carrier load error:", error)
        }
    }
    
    private func normalizeEmpty(_ s: String?) -> String? {
        guard let s, !s.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return nil }
        return s
    }
}
