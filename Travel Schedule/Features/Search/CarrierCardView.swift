import SwiftUI

struct CarrierCardView: View {
    let title: String
    let logoURL: URL?
    let phone: String?
    let email: String?
    
    var body: some View {
        ZStack {
            Color(.ypWhiteU).ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Spacer()
                        CarrierLogo(url: logoURL)
                        Spacer()
                    }
                    .padding(.top, 28)
                    
                    Text(title)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(Color(.ypBlackU))
                        .padding(.top, 28)
                    
                    VStack(alignment: .leading, spacing: 22) {
                        if let email, !email.isEmpty {
                            LabeledLink(
                                title: "E-mail",
                                value: email,
                                url: URL(string: "mailto:\(email)")
                            )
                        }
                        
                        if let phone, !phone.isEmpty {
                            LabeledLink(
                                title: "Телефон",
                                value: phone,
                                url: URL(string: "tel:\(sanitizePhoneForTel(phone))")
                            )
                        }
                        
                        if (email?.isEmpty ?? true) && (phone?.isEmpty ?? true) {
                            Text("Контакты не указаны")
                                .foregroundStyle(Color(.ypGray))
                                .padding(.top, 6)
                        }
                    }
                    .padding(.top, 26)
                    
                    Spacer(minLength: 24)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
        }
        .navigationTitle("Информация о перевозчике")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func sanitizePhoneForTel(_ raw: String) -> String {
        raw.filter { $0.isNumber || $0 == "+" }
    }
}

private struct CarrierLogo: View {
    let url: URL?
    
    var body: some View {
        Group {
            if let url {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let img):
                        img.resizable().scaledToFit()
                    default:
                        placeholder
                    }
                }
            } else {
                placeholder
            }
        }
        .frame(height: 90)
    }
    
    private var placeholder: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color(.ypLightGray))
            .frame(width: 160, height: 90)
    }
}

private struct LabeledLink: View {
    let title: String
    let value: String
    let url: URL?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(Color(.ypBlackU))
            
            if let url {
                Link(value, destination: url)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(Color(.ypBlue))
            } else {
                Text(value)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(Color(.ypGray))
            }
        }
    }
}
