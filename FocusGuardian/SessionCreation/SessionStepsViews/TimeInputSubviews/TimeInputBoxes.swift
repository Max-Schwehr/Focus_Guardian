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
    @Binding var lives: Int
    
    // Single-digit hour (0–9)
    @State var hourDigit1: String = ""
    // Minute digits (00–59)
    @State var minuteDigit1: String = ""
    @State var minuteDigit2: String = ""
    
    var allFieldsFilled: Bool {
        !hourDigit1.isEmpty && !minuteDigit1.isEmpty && !minuteDigit2.isEmpty
    }
    
    @FocusState var currentFocus: CurrentDigitFocus?
    
    var body: some View {
        HStack(spacing: 8) {
            DigitInputView(input: $hourDigit1)
                .focused($currentFocus, equals: .hourDigit1)
                .onChange(of: hourDigit1) { _, newValue in
//                    let sanitized = sanitizeToSingleDigit(newValue)
//                    let sanitizedString = String(sanitized)
//                    if sanitizedString != hourDigit1 { hourDigit1 = sanitizedString }
//                    advanceFocusIfTextboxFilled()
                }
                .submitLabel(.next)
            
            Text("Hr,   ")
                .font(.largeTitle)
            
            DigitInputView(input: $minuteDigit1)
                .focused($currentFocus, equals: .minuteDigit1)
                .onChange(of: minuteDigit1) { _, newValue in
//                    let sanitized = sanitizeToSingleDigit(newValue)
//                    let sanitizedString = String(sanitized)
//                    if sanitizedString != minuteDigit1 { minuteDigit1 = sanitizedString }
////                    advanceFocusIfTextboxFilled()
                }
                .submitLabel(.next)
            
            DigitInputView(input: $minuteDigit2)
                .focused($currentFocus, equals: .minuteDigit2)
                .onChange(of: minuteDigit2) { _, newValue in
//                    let sanitized = sanitizeToSingleDigit(newValue)
//                    let sanitizedString = String(sanitized)
//                    if sanitizedString != minuteDigit2 { minuteDigit2 = sanitizedString }
////                    advanceFocusIfTextboxFilled()
                }
                .submitLabel(.done)
            Text("Min")
                .font(.largeTitle)
        }
        .onAppear { currentFocus = .hourDigit1 }
        .padding()
        .glassEffect()
        .animation(.smooth, value: allFieldsFilled)
        .onChange(of: [hourDigit1, minuteDigit1, minuteDigit2]) { _, _ in
//            if allFieldsFilled {
////                updateBindingsFromInput()
//            } else {
//                hours = 0
//                minutes = 0
//                lives = 0
//            }
        }
        .onChange(of: [hours, minutes], { oldValue, newValue in
//            setInputBoxes(hours: hours, minutes: minutes)
        })
//        .onKeyPress { kp in
//            switch kp.key {
//            case .leftArrow:
//                retreatFocus()
//                return .handled
//
//            case .rightArrow:
//                advanceFocus()
//                return .handled
//            default:
//                return .ignored
//            }
//        }
    .onDisappear {
//        updateBindingsFromInput()
    }
    }
}

#Preview {
    TimeInputBoxes(hours: .constant(5), minutes: .constant(3), lives: .constant(3))
        .padding()
        .background(Color.gray.opacity(0.1))
}
