import SwiftUI

struct TripCardView: View {
    let item: TripOption
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(alignment: .top, spacing: 12) {
                CarrierLogoView(title: item.carrierTitle, logoURL: item.carrierLogoURL)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(item.carrierTitle)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(Color("YPBlackU"))
                    
                    if let transfer = item.transferText, !transfer.isEmpty {
                        Text(transfer)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(Color("YPRed"))
                    }
                }
                
                Spacer()
                
                Text(item.dateText)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(Color("YPBlackU"))
            }
            
            HStack(spacing: 10) {
                Text(item.departureTime)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(Color("YPBlackU"))
                
                DividerLine()
                
                Text(item.durationText)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(Color("YPBlackU"))
                
                DividerLine()
                
                Text(item.arrivalTime)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(Color("YPBlackU"))
            }
        }
        .padding(14)
        .background(Color("YPLightGray"))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

private struct DividerLine: View {
    var body: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundStyle(Color("YPGray").opacity(0.35))
            .frame(maxWidth: .infinity)
    }
}

private struct CarrierLogoView: View {
    let title: String
    let logoURL: URL?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.white)
            
            if let url = logoURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .padding(6)
                    case .failure, .empty:
                        initialsView
                    @unknown default:
                        initialsView
                    }
                }
            } else {
                initialsView
            }
        }
        .frame(width: 44, height: 44)
        .clipped()
    }
    
    private var initialsView: some View {
        Text(initials(from: title))
            .font(.system(size: 14, weight: .bold))
            .foregroundStyle(Color("YPGray"))
    }
    
    private func initials(from s: String) -> String {
        let parts = s.split(separator: " ")
        let a = parts.first?.first.map(String.init) ?? "?"
        let b = parts.dropFirst().first?.first.map(String.init) ?? ""
        return (a + b).uppercased()
    }
}
