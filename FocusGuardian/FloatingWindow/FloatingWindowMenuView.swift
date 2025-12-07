import SwiftUI

#if os(macOS)
struct FloatingWindowMenuView: View {
    let size: CGSize
    var cornerRadius: CGFloat = 25
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Spacer()
                Text("Focus Timer")
                    .bold()
                VStack(alignment: .leading, spacing: 7) {
                    Text("Time Remaining: 1hr, 37m, 21s")
                    Text("Time Elapsed: 23m, 39s")
                    Text("Lives Used: 2 out of 4")
                }
                Spacer()
            }
            Spacer()
        }
        .padding(20)
        .frame(width: size.width, height: size.height)
        .glassEffect(.clear.interactive(), in: .rect(cornerRadius: cornerRadius))
        .offset(x: -10, y: 50)
        .transition(
            .scale(scale: 0.0, anchor: .topTrailing)
            .combined(with: .opacity)
            .combined(with:
                    .modifier(
                        active: BlurModifier(radius: 30),
                        identity: BlurModifier(radius: 0)
                    )
            )
        )
    }
}

struct BlurModifier: ViewModifier {
    let radius: CGFloat
    func body(content: Content) -> some View {
        content.blur(radius: radius)
    }
}

#Preview {
    FloatingWindowMenuView(size: CGSize(width: 250, height: 120))
        .offset(x: 10, y: -50)
}
#endif
