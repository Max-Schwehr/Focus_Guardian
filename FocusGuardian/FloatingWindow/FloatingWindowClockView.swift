import SwiftUI

#if os(macOS)
struct FloatingWindowClockView: View {
    @Binding var minutesRemaining: Int
    let size: CGSize

    var body: some View {
        HStack(spacing: 10) {
            Text(minutesToHoursAndMinutes(seconds: minutesRemaining, showSeconds: true))
        }
        .frame(width: size.width, height: size.height)
        .bold()
        .glassEffect()
    }
}

#Preview {
    FloatingWindowClockView(minutesRemaining: .constant(120), size: CGSize(width: 150, height: 40))
}
#endif
