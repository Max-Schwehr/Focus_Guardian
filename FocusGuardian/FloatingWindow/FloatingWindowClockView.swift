import SwiftUI

#if os(macOS)
struct FloatingWindowClockView: View {
    @Binding var secondsRemaining: Int
    let size: CGSize
    let normalTimerSize  = CGSize(width: 100, height: 40)
    @Binding var livesLost : Int
    @Binding var requestedLivesSize : CGSize
    var body: some View {
        HStack(spacing: 10) {
            if size.height > normalTimerSize.height {
                FaceNotVisible(livesLost: $livesLost, requestedLivesSize: $requestedLivesSize)
            } else {
                Text(secondsToPresentableTime(seconds: secondsRemaining, showSeconds: false))
                    .bold()
            }
        }
        .frame(width: size.width, height: size.height)
        .glassEffect()
        .animation(.spring(), value: size)
        
    }
}

#Preview {
    FloatingWindowClockView(secondsRemaining: .constant(120), size: CGSize(width: 200, height: 80), livesLost: .constant(3), requestedLivesSize: .constant(CGSize(width: 250, height: 110)))
        .padding()
}
#endif
