//
//  FaceNotVisable.swift
//  FocusGuardian
//
//  Created by Maximiliaen Schwehr on 12/20/25.
//

import SwiftUI
import Combine

struct FaceNotVisible: View {
    @State private var pulse = false
    @State private var timerCancellable: AnyCancellable?
    @State private var percent = 0.1

    var body: some View {
        ZStack {
            HStack {
                expansivePlane
                    .glassEffect(.regular.tint(.red))
                    .opacity(0.7)
            }
            .mask {
                GeometryReader { geometry in
                    Rectangle()
                        .foregroundStyle(Color.red)
                        .frame(width: geometry.size.width * percent)
                        .onAppear {
                            timerCancellable = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
                                .sink { _ in
                                    if percent < 1 {
                                        percent = min(percent + (0.01 / 6), 1)
                                    } else {
                                        print("Timer Ended!")
                                        timerCancellable?.cancel()
                                    }
                                }
                        }
                        .onDisappear {
                            timerCancellable?.cancel()
                        }
                }
            }
            Label("Face not visible", systemImage: "exclamationmark.triangle")
                .fontWeight(.medium)
                .opacity(pulse ? 1.0 : 0.7)
                .scaleEffect(pulse ? 1 : 0.95)
                .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true),
                           value: pulse)
                .onAppear { pulse = true }
        }
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
