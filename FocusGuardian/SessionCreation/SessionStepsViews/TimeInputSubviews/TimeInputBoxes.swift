//
//  TimeInputBoxes.swift
//  FocusGuardian
//
//  Created by Maximiliaen Schwehr on 1/5/26.
//

import SwiftUI



struct TimeInputBoxes: View {
    // Bindings for output values
    @Binding var hours: Int
    @Binding var minutes: Int
    @Binding var lives: Int?
    
    @State var hourDigit1: Int? = nil
    @State var minuteDigit1: Int? = nil
    @State var minuteDigit2: Int? = nil
        
    @FocusState var currentFocus: CurrentDigitFocus?
    
    var body: some View {
        VStack {
            Text("Hours : Minutes")
                .foregroundStyle(.secondary)
            HStack(spacing: 8) {
                DigitInputView(placeholder: "0", input: $hourDigit1)
                    .focused($currentFocus, equals: .hourDigit1)
                    .submitLabel(.next)
                
                Text(":")
                
                DigitInputView(placeholder: "3", input: $minuteDigit1)
                    .focused($currentFocus, equals: .minuteDigit1)
                    .submitLabel(.next)
                
                DigitInputView(placeholder: "0", input: $minuteDigit2)
                    .focused($currentFocus, equals: .minuteDigit2)
                    .submitLabel(.done)
            }
            .font(.largeTitle)
            .bold()
            .fontDesign(.monospaced)
            .onAppear { currentFocus = .hourDigit1 }
            .padding()
            .glassEffect()
           
        } .onKeyPress { kp in
            switch kp.key {
            case .leftArrow:
                retreatFocus()
                return .handled
            case .rightArrow, .tab:
                print("Testing")
                progressFocus()
                return .handled
            default:
                return .ignored
            }
        }
    }
    
    /// Progress the current focus to the next textbox, if the focus is currently the last textbox, its sets the focus to nil
    func progressFocus() {
        if currentFocus == .hourDigit1 {
            currentFocus = .minuteDigit1
        } else if currentFocus == .minuteDigit1 {
            currentFocus = .minuteDigit2
        } else if currentFocus == .minuteDigit2 {
            currentFocus = nil
        }
    }
    
    /// Retreat the current focus to the previous textbox; if the focus is currently the first textbox (or nil), set the focus to nil
    func retreatFocus() {
        if currentFocus == .minuteDigit2 {
            currentFocus = .minuteDigit1
        } else if currentFocus == .minuteDigit1 {
            currentFocus = .hourDigit1
        } else if currentFocus == .hourDigit1 {
            currentFocus = nil
        }
    }
}

#Preview {
    TimeInputBoxes(hours: .constant(5), minutes: .constant(3), lives: .constant(3))
        .padding()
        .background(Color.gray.opacity(0.1))
}

