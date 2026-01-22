import SwiftUI

struct CarrierCardView: View {
    var body: some View {
        ZStack {
            Color(.ypWhiteU).ignoresSafeArea()
            Text("Карточка перевозчика (заглушка)")
                .foregroundStyle(Color(.ypGray))
        }
        .navigationTitle("Перевозчик")
        .navigationBarTitleDisplayMode(.inline)
    }
}
