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
    @Binding var livesLost : Int
    @Binding var requestedLivesSize : CGSize

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
                                        Task {
                                            requestedLivesSize = CGSize(width: 250, height: getFloatingHeartsWindowHeight(numberOfHearts: 3)) // MARK: Todo
                                            try await Task.sleep(for: .seconds(1))
                                            livesLost += 1
                                            try await Task.sleep(for: .seconds(1))
                                            requestedLivesSize = CGSize(width: 0, height: 0)
                                        }
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
    FloatingWindowClockView(secondsRemaining: .constant(120), size: CGSize(width: 200, height: 80), livesLost: .constant(3), requestedLivesSize: .constant(CGSize(width: 250, height: 110)))
        .padding()
}
