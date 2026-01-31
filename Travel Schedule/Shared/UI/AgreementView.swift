import SwiftUI

struct AgreementView: View {
    @Environment(\.dismiss) private var dismiss

    private var url: URL? {
        URL(string: "https://yandex.ru/legal/practicum_termsofuse/")
    }

    var body: some View {
        Group {
            if let url {
                AgreementWebView(url: url)
            } else {
                Color.clear
                    .onAppear {
                        dismiss()
                    }
            }
        }
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
