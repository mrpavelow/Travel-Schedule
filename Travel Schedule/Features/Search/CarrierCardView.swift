import SwiftUI

struct CarrierCardView: View {
    var body: some View {
        ZStack {
            Color("YPWhiteU").ignoresSafeArea()
            Text("Карточка перевозчика (заглушка)")
                .foregroundStyle(Color("YPGray"))
        }
        .navigationTitle("Перевозчик")
        .navigationBarTitleDisplayMode(.inline)
    }
}
