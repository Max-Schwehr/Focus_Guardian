import SwiftUI

#if os(macOS)
struct FloatingWindowClockView: View {
    @Binding var secondsRemaining: Int
    let size: CGSize
    let normalTimerSize  = CGSize(width: 100, height: 40)
    @State var timeElapsed : Int = 0
    @State var timerWidth : CGFloat = 0
    var body: some View {
        HStack(spacing: 10) {
            if size.height > normalTimerSize.height {
                HStack {
                    expansivePlane
                        .glassEffect(.regular.tint(.red), in: .rect(cornerRadius: 16.0))
                        .opacity(0.7)
                        .frame(width: timerWidth)
                        .padding(10)
                    
                    Spacer()
                }
                .mask {
                    GeometryReader { geometry in
                        expansivePlane
                            .glassEffect(.regular.tint(.orange).interactive())
                            .padding(10)
                            .task { // Reduces seconds remaining by 1 every second
                                while timeElapsed <= 5 {
                                    print("SUP YALL")
                                    try? await Task.sleep(for: .seconds(1))
                                    secondsRemaining += 1
                                    withAnimation {
                                        timerWidth = geometry.size.width / CGFloat(secondsRemaining)
                                    }
                                }
                            }
                    }
                }
               
                
                
            } else {
                Text(minutesToHoursAndMinutes(seconds: secondsRemaining, showSeconds: false))
            }
        }
        .frame(width: size.width, height: size.height)
        .bold()
        .glassEffect()
        .animation(.spring(), value: size)
        
    }
    
    var expansivePlane: some View {
        HStack {
            VStack { Spacer() }
            Spacer()
        }
    }
}

#Preview {
    FloatingWindowClockView(secondsRemaining: .constant(120), size: CGSize(width: 200, height: 80))
        .padding()
}
#endif

