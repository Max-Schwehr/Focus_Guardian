//
//  DigitInputView.swift
//
//  Created by Maximiliaen Schwehr on 11/8/25.
//

import SwiftUI

struct DigitInputView: View {
    @Binding var input: String

    var body: some View {
//        TextField("", text: $input)
//            .disableAutocorrection(true)
//            .fontDesign(.monospaced)
//            .bold()
//            .font(.largeTitle)
//            .multilineTextAlignment(.center)
//            .frame(width: 45)
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
}
