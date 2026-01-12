import SwiftUI

struct CheckRow: View {
    let title: String
    let isChecked: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Text(title)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(Color("YPBlackU"))

                Spacer()

                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color("YPBlackU"), lineWidth: 2)
                        .frame(width: 22, height: 22)

                    if isChecked {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color("YPBlackU"))
                            .frame(width: 22, height: 22)

                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(Color.white)
                    }
                }
            }
        }
        .buttonStyle(.plain)
    }
}

struct RadioRow: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Text(title)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(Color("YPBlackU"))

                Spacer()

                ZStack {
                    Circle()
                        .stroke(Color("YPBlackU"), lineWidth: 2)
                        .frame(width: 22, height: 22)

                    if isSelected {
                        Circle()
                            .fill(Color("YPBlackU"))
                            .frame(width: 10, height: 10)
                    }
                }
            }
        }
        .buttonStyle(.plain)
    }
}
