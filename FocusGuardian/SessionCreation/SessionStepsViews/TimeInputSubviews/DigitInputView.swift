//
//  DigitInputView.swift
//
//  Created by Maximiliaen Schwehr on 11/8/25.
//

import SwiftUI

struct DigitInputView: View {
    @Binding var input: String
    @FocusState private var isFocused: Bool
    @State private var isBlinking: Bool = false
    
    private var shouldBlink: Bool { isFocused && !input.isEmpty }
    
    var body: some View {
        TextField("", text: $input)
            .focused($isFocused)
            .textFieldStyle(.plain)
            .background(.clear)
            .opacity(shouldBlink ? (isBlinking ? 0.15 : 1.0) : 1.0)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .frame(width: 45, height: 50)
            .glassEffect()
            .fontDesign(.monospaced)
            .bold()
            .font(.largeTitle)
            .multilineTextAlignment(.center)
            .onChange(of: shouldBlink) { active in
                if active { isBlinking = true } else { isBlinking = false }
            }
            .onAppear {
                // Initialize state in case it starts focused
                isBlinking = shouldBlink
            }
            .animation(shouldBlink ? .easeInOut(duration: 0.6).repeatForever(autoreverses: true) : .default, value: shouldBlink)
            .animation(shouldBlink ? .easeInOut(duration: 0.6).repeatForever(autoreverses: true) : .default, value: isBlinking)
    }
}

// This is a helper method that parent files can call to allow the output of this function to be "sanitized"
func sanitizeToSingleDigit(_ text: String) -> Int {
    // Keep only the first numeric character; if none, treat as 0
    if let ch = text.first(where: { $0.isNumber }) {
        return ch.wholeNumberValue ?? 0
    } else {
        return 0
    }
}


#Preview {
    DigitInputView(input: .constant("5"))
        .padding()
}

