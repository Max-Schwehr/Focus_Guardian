import SwiftUI

#if os(macOS)
struct FloatingClockView: View {
    @Binding var size: CGSize
    @Binding var secondsRemaining: Int
    @Binding var livesLost : Int
    @Binding var requestedLivesSize : CGSize
    @Binding var viewContentOptions : FloatingClockViewContentOptions
    var body: some View {
        HStack(spacing: 10) {
            switch viewContentOptions {
            case .Clock:
                Text(secondsToPresentableTime(seconds: secondsRemaining, showSeconds: false))
                    .bold()
            case .FaceNotVisible:
                FaceNotVisible(livesLost: $livesLost, requestedLivesSize: $requestedLivesSize)
            case .TimerCompletedView:
                TimerCompletedView(size: $size)
            }
        }
        .mask {
            expansivePlane
                .frame(width: size.width, height: size.height)
                .modifier(GlassEffectWithVariableCornerRadius(reduceRoundness: viewContentOptions == .TimerCompletedView))
        }
        .frame(width: size.width, height: size.height)
        .modifier(GlassEffectWithVariableCornerRadius(reduceRoundness: viewContentOptions == .TimerCompletedView))
    }
}

// The timer can expand, and some of the content options need a different corner radius, which is specified using this...
private struct GlassEffectWithVariableCornerRadius: ViewModifier {
    let reduceRoundness: Bool
    func body(content: Content) -> some View {
        if reduceRoundness {
            content.glassEffect(in: .rect(cornerRadius: 25.0))
        } else {
            content.glassEffect()
        }
    }
}

#Preview {
    FloatingClockView(size: .constant(CGSize(width: 200, height: 80)), secondsRemaining: .constant(120), livesLost: .constant(3), requestedLivesSize: .constant(CGSize(width: 250, height: 110)), viewContentOptions: .constant(.Clock))
        .padding()
}
#endif
