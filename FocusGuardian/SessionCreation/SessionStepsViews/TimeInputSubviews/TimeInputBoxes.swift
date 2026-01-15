//
//  TimeInputBoxes.swift
//  FocusGuardian
//
//  Created by Maximiliaen Schwehr on 1/5/26.
//

import SwiftUI



struct TimeInputBoxes: View {
    // Bindings for output values
    @Binding var length: Int?
    @Binding var lives: Int?
    
    @State var hourDigit1: Int? = nil
    @State var minuteDigit1: Int? = nil
    @State var minuteDigit2: Int? = nil
        
    @FocusState var currentFocus: CurrentDigitFocus?
    
    var body: some View {
        VStack {
            // MARK: - Title Section
            Text("Enter Focus Length")
                .bold()
                .font(.title3)
            
            // Tells the user how to format their response
            Text("Hours : Minutes")
                .foregroundStyle(.secondary)
                .onAppear(perform: pullValues)
                .onChange(of: length, pullValues)
                .onDisappear(perform: pushValues)
                
            
            // MARK: Digit Views
            HStack(spacing: 8) {
                // Hour Digit
                DigitInputView(placeholder: "0", maxValue: .constant(3), input: $hourDigit1, retreatFocus: retreatFocus, progressFocus: progressFocus)
                    .focused($currentFocus, equals: .hourDigit1)
                    .submitLabel(.next)
                
                Text(":")
                
                // Minute Digit 1
                DigitInputView(placeholder: "3", maxValue: .constant(6), input: $minuteDigit1, retreatFocus: retreatFocus, progressFocus: progressFocus)
                    .focused($currentFocus, equals: .minuteDigit1)
                    .submitLabel(.next)
                
                // Minute Digit 2
                DigitInputView(placeholder: "0", maxValue: Binding(
                    // If `minuteDigit1` is 6, this value must be zero; as you can't have values like 69 minutes.
                    get: { (minuteDigit1 ?? 0) == 6 ? 0 : 9 },
                    set: { _ in }
                ), input: $minuteDigit2, retreatFocus: retreatFocus, progressFocus: progressFocus)
                    .focused($currentFocus, equals: .minuteDigit2)
                    .submitLabel(.done)
            }
            .font(.largeTitle)
            .bold()
            .fontDesign(.monospaced)
            .onAppear { currentFocus = .hourDigit1 }
            .padding()
            .glassEffect()
           
        }
        // MARK: Manage arrow keys, and tab key
        .onKeyPress { kp in
            switch kp.key {
            case .leftArrow:
                retreatFocus()
                return .handled
            case .rightArrow, .tab:
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

    /// Takes `hourDigit1`, `minuteDigit1`, and `minuteDigit2` and updates the `length` variable so their content is available to parent views.
    func pushValues() {
        if hourDigit1 == nil || minuteDigit1 == nil || minuteDigit2 == nil {
            length = nil
            return
        }
        // These values should never be `nil` as `hasValidValues` was ran, but to be safe it defaults to 0
        let minutes = (minuteDigit1 ?? 0) * 10 + (minuteDigit2 ?? 0)
        length = (hourDigit1 ?? 0) * 60 + minutes
        
        print("Values Pushed, length = \(length)")
    }
    
    /// Takes `length` and converts it to `hourDigit1`, `minuteDigit1`, and `minuteDigit2` so `length`'s content can be rendered on screen.
    func pullValues() {
        guard let lengthUnwrapped = length else {
            hourDigit1 = nil
            minuteDigit1 = nil
            minuteDigit2 = nil
            return
        }
        
        hourDigit1 = lengthUnwrapped / 60
    
        let minutes = lengthUnwrapped % 60
        minuteDigit1 = minutes / 10
        minuteDigit2 = minutes % 10
    }
}

#Preview {
    TimeInputBoxes(length: .constant(5), lives: .constant(3))
        .padding()
        .background(Color.gray.opacity(0.1))
}

