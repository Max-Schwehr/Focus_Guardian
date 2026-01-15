//
//  DigitInputView.swift
//
//  Created by Maximiliaen Schwehr on 11/8/25.
//

import SwiftUI
import AppKit

struct DigitInputView: View {
    let placeholder : String
    @Binding var input: Int?
    @FocusState private var isFocused: Bool
    var body: some View {
        ZStack {
            // MARK: Text Feild
            NumericTextField(input: $input)
                .focused($isFocused)
                .textFieldStyle(.plain)
                .background(.clear)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .frame(width: 45, height: 50)
                .glassEffect(.clear)
                .fontDesign(.monospaced)
                .bold()
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .onChange(of: input) { oldValue, newValue in
                    guard let inputUnwrapped = newValue else { return }
                    input = min(inputUnwrapped, 6)
                }
            
            // MARK: Invisible Click Target
            // Intercepts the user when they try to click on the textbox, preventing the curser from going before the digit.
            Color.clear
                .frame(width: 45, height: 50)
                .contentShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .onTapGesture {
                    // Adjust `isFocused` which will highlight the content of the textfield
                    isFocused = true
                }
        }
    }
}

// MARK: A NumericTextField that does not accept non-numbers
// Note: Apple has a implementation of this with their normal textfields on a numerical mode, however, it allows the user to type letters, but does not pass them into any variables. I dont want this behavior, thus my own implantation below...
struct NumericTextField : View {
    @Binding var input: Int?
    @State private var stringInput : String = ""
    var body: some View {
        TextField("", text: $stringInput)
            // MARK: Int? - > String
            .onChange(of: input) { oldValue, newValue in
                if let inputUnwrapped = input {
                    stringInput = String(inputUnwrapped)
                } else {
                    stringInput = ""
                }
            }
            // MARK: String -> Int?
            .onChange(of: stringInput) { oldValue, newValue in
                if let stringInputAsInt = Int(stringInput) {
                    input = stringInputAsInt
                } else {
                    stringInput = ""
                    input = nil
                }
            }
        
            // MARK: Key Register System
            // Checks to see if you press delete, in which there is extra functions to be ran.
            // Makes sure there can only be one character in the textfield at a time.
            .onKeyPress(action: { keyPress in
                if keyPress.key == "\u{7F}" {
                    print("Delete Pressed")
                }
                stringInput = keyPress.characters
                return .handled
            })
    }
}

#Preview {
    DigitInputView(placeholder: "1", input: .constant(5))
        .padding()
}
