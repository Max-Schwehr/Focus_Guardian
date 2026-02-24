//
//  LivesInputView.swift
//
//  Created by Maximiliaen Schwehr on 11/8/25.
//

import SwiftUI

struct LivesInputView: View {
    @Binding var lives: Int?
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 6) {
                Text("Enter Life Count")
                    .bold()
                    .font(.title3)

                Text("Represents the number of lives you have while focusing. \nIf you break focus, you lose a life!")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
            }
            ZStack {
                DigitInputView(placeholder: "5", maxValue: .constant(10), input: $lives, retreatFocus: {}, progressFocus: {})
            }
                .font(.largeTitle)
                .bold()
                .fontDesign(.monospaced)
                .padding()
                .glassEffect()
                .padding()
        }
    }
}

#Preview {
    LivesInputView(lives: .constant(0))
        .padding()
        .background(.gray.opacity(0.1))
}
