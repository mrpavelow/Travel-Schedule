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
                    .foregroundStyle(Color(.ypBlackU))

                Spacer()

                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color(.ypBlackU), lineWidth: 2)
                        .frame(width: 22, height: 22)

                    if isChecked {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(.ypBlackU))
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
                    .foregroundStyle(Color(.ypBlackU))

                Spacer()

                ZStack {
                    Circle()
                        .stroke(Color(.ypBlackU), lineWidth: 2)
                        .frame(width: 22, height: 22)

                    if isSelected {
                        Circle()
                            .fill(Color(.ypBlackU))
                            .frame(width: 10, height: 10)
                    }
                }
            }
        }
        .buttonStyle(.plain)
    }
}
