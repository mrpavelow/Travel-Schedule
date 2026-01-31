import SwiftUI

struct CloseButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color.ypBlack)
                
                Image(.close)
            }
            .frame(width: 30, height: 30)
        }
        .buttonStyle(.plain)
        .contentShape(Circle())
    }
}
