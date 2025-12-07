import SwiftUI

#if os(macOS)
struct FloatingWindowClockView: View {
    let timeText: String
    let size: CGSize

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "alarm")
            Text(timeText)
        }
        .frame(width: size.width, height: size.height)
        .bold()
        .glassEffect()
    }
}

#Preview {
    FloatingWindowClockView(timeText: "07:00 AM", size: CGSize(width: 150, height: 40))
}
#endif
