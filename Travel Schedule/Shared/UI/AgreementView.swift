import SwiftUI

struct AgreementView: View {
    @Environment(\.dismiss) private var dismiss
    
    private let url = URL(string: "https://yandex.ru/legal/practicum_termsofuse/")!
    
    var body: some View {
        AgreementWebView(url: url)
            .navigationTitle("Пользовательское соглашение")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                    }
                }
            }
    }
}
