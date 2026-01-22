import SwiftUI

enum ErrorScreenKind {
    case noInternet
    case serverError

    var title: String {
        switch self {
        case .noInternet:  return "Нет интернета"
        case .serverError: return "Ошибка сервера"
        }
    }

    var assetImageName: String {
        switch self {
        case .noInternet:  return "no_internet"
        case .serverError: return "server_error"
        }
    }
}

struct ErrorScreen: View {
    let kind: ErrorScreenKind

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack {
                Spacer()

                VStack(spacing: 16) {
                    Image(kind.assetImageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 223, height: 223)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 70, style: .continuous)
                        )

                    Text(kind.title)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.black)
                }

                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Конкретные экраны

struct NoInternetScreen: View {
    var body: some View { ErrorScreen(kind: .noInternet) }
}

struct ServerErrorScreen: View {
    var body: some View { ErrorScreen(kind: .serverError) }
}
