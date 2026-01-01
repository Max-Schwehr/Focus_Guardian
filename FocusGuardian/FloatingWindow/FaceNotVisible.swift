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
    @State private var width : CGFloat = 0
    @Binding var livesLost : Int
    @Binding var requestedLivesSize : CGSize
    
    var body: some View {
        ZStack {
            Label("Face not visible", systemImage: "exclamationmark.triangle")
                .fontWeight(.medium)
                .scaleEffect(pulse ? 1 : 0.95)
                .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true),
                           value: pulse)
                .onAppear { pulse = true }
            
            // MARK: Red Part
            Rectangle()
                .foregroundStyle(Color.red)
                .opacity(0.65)
                .mask {
                    // MARK: First mask gives it liquid glass shape
                    expansivePlane
                        .glassEffect(.regular)
                        .mask {
                            // MARK: Second mask cut off a percent of the red part so it can n act as a timer
                            GeometryReader { geometry in
                                Rectangle()
                                    .frame(width: width)
                                    .onAppear {
                                        timerCancellable = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
                                            .sink { _ in
                                                if percent < 1 {
                                                    percent = min(percent + (0.01 / 6), 1)
                                                    width = geometry.size.width * percent
                                                } else {
                                                    print("Timer Ended!")
                                                    timerCancellable?.cancel()
                                                    Task {
                                                        requestedLivesSize = CGSize(width: 250, height: 100)
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
                }
            Label("Face not visible", systemImage: "exclamationmark.triangle")
                .fontWeight(.medium)
                .scaleEffect(pulse ? 1 : 0.95)
                .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true),
                           value: pulse)
                .foregroundStyle(.white)
                .mask {
                        expansivePlane
                            .glassEffect(.regular)
                            .mask {
                                HStack {
                                    Rectangle()
                                        .frame(width: max(0, width - 40))
                                    Spacer()
                                }
                            }
                }
        }
    }
    
    
}

var expansivePlane: some View {
    HStack {
        VStack { Spacer() }
        Spacer()
    }
}

#Preview {
    FaceNotVisible(livesLost: .constant(0), requestedLivesSize: .constant(CGSize(width: 250, height: 80)))
        .frame(width: 250, height: 80)
}
