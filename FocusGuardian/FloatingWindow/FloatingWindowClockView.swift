import SwiftUI

#if os(macOS)
struct FloatingWindowClockView: View {
    @Binding var secondsRemaining: Int
    let size: CGSize

    var body: some View {
        HStack(spacing: 10) {
            Text(minutesToHoursAndMinutes(seconds: secondsRemaining, showSeconds: false))
        }
        .frame(width: size.width, height: size.height)
        .bold()
        .glassEffect()
        .animation(.spring(), value: size)

    }
}

#Preview {
    FloatingWindowClockView(secondsRemaining: .constant(120), size: CGSize(width: 150, height: 40))
}
#endif
