import SwiftUI

struct SelectionRow: View {
    let title: String
    let value: String?
    let placeholder: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 13))
                        .foregroundStyle(Color("YPGray"))
                    Text(value ?? placeholder)
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(value == nil ? Color("YPGray") : Color("YPBlackU"))
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color("YPGray"))
            }
            .padding(.vertical, 10)
        }
    }
}
