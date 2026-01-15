//
//  LivesInputView.swift
//
//  Created by Maximiliaen Schwehr on 11/8/25.
//

import SwiftUI

struct LivesInputView: View {
    @Binding var lives: Int?
    @FocusState private var isFocused: Bool
//
//    init(lives: Binding<Int>) {
//        self._lives = lives
//        self._livesAsString = State(initialValue: String(lives.wrappedValue))
//    }

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 6) {
                Text("Enter Life Count")
                    .bold()
                    .font(.title3)

                Text("Represents the number of lives you have while focusing. \nIf you break focus, you lose a life!")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)

                Label("\(lives) Lives Recommended", systemImage: "")
                    .foregroundStyle(.secondary)
            }

            DigitInputView(placeholder: "", input: $lives)
                .focused($isFocused)
                .padding()
                .background(.white)
                .cornerRadius(20)
                .padding(.top, 20)
                .onAppear { isFocused = true }
//                .onChange(of: livesAsString) { oldValue, newValue in
//                    if let value = Int(livesAsString) {
//                        lives = value
//                    }
//                }
//                .onChange(of: lives) { oldValue, newValue in
//                    livesAsString = String(lives)
//                }
        }
    }
}

#Preview {
    LivesInputView(lives: .constant(0))
        .padding()
        .background(.gray.opacity(0.1))
}
