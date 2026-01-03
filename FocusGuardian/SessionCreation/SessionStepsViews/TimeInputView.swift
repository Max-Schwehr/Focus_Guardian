//
//  TimeInputView.swift
//
//  Created by Maximiliaen Schwehr on 11/7/25.
//

import SwiftUI

/// Identifies which single-character digit field currently has focus.
private enum CurrentDigitFocus: Hashable {
    case hourDigit1
    case minuteDigit1
    case minuteDigit2
}

struct TimeInputView: View {
    // Bindings for output values
    @Binding var hours: Int
    @Binding var minutes: Int
    @Binding var lives: Int

    // Single-digit hour (0–9)
    @State private var hourDigit1: String = ""
    // Minute digits (00–59)
    @State private var minuteDigit1: String = ""
    @State private var minuteDigit2: String = ""

    private var allFieldsFilled: Bool {
        !hourDigit1.isEmpty && !minuteDigit1.isEmpty && !minuteDigit2.isEmpty
    }

    @FocusState private var currentFocus: CurrentDigitFocus?


    // MARK: - Body

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 6) {
                Text("Enter Focus Length")
                    .bold()
                    .font(.title3)

                Text("Hours and Minutes")
                    .foregroundStyle(.secondary)
                
                if allFieldsFilled && computeOutput() == nil {
                    HStack(spacing: 6) {
                        Text("Enter a valid time to continue")
                    }
                    .foregroundStyle(.red)
                    .transition(.opacity)
                }
            }
            
            HStack(spacing: 8) {
                DigitInputView(input: $hourDigit1)
                    .focused($currentFocus, equals: .hourDigit1)
                    .onChange(of: hourDigit1) { _, newValue in
                        let sanitized = sanitizeToSingleDigit(newValue)
                        let sanitizedString = String(sanitized)
                        if sanitizedString != hourDigit1 { hourDigit1 = sanitizedString }
                        advanceFocusIfTextboxFilled()
                    }
                    .submitLabel(.next)
                
                Text(":")
                    .font(.largeTitle)
                
                DigitInputView(input: $minuteDigit1)
                    .focused($currentFocus, equals: .minuteDigit1)
                    .onChange(of: minuteDigit1) { _, newValue in
                        let sanitized = sanitizeToSingleDigit(newValue)
                        let sanitizedString = String(sanitized)
                        if sanitizedString != minuteDigit1 { minuteDigit1 = sanitizedString }
                        advanceFocusIfTextboxFilled()
                    }
                    .submitLabel(.next)
                
                DigitInputView(input: $minuteDigit2)
                    .focused($currentFocus, equals: .minuteDigit2)
                    .onChange(of: minuteDigit2) { _, newValue in
                        let sanitized = sanitizeToSingleDigit(newValue)
                        let sanitizedString = String(sanitized)
                        if sanitizedString != minuteDigit2 { minuteDigit2 = sanitizedString }
                        advanceFocusIfTextboxFilled()
                    }
                    .submitLabel(.done)
            }
            .onAppear { currentFocus = .hourDigit1 }
            .padding()
            .background(.background)
            .cornerRadius(20)
            .animation(.smooth, value: allFieldsFilled)
            .onChange(of: [hourDigit1, minuteDigit1, minuteDigit2]) { _, _ in
                if allFieldsFilled {
                    updateBindingsFromInput()
                } else {
                    hours = 0
                    minutes = 0
                    lives = 0
                }
            }
            .onKeyPress { kp in
                switch kp.key {
                case .leftArrow:
                    retreatFocus()
                    return .handled

                case .rightArrow:
                    advanceFocus()
                    return .handled
                default:
                    return .ignored
                }
            }        }
        .onDisappear {
            updateBindingsFromInput()
        }
    }
    
    /// Advances focus to the next field when the current one has a single character.
    /// When the last field is filled and all fields are valid, updates bound values.
    private func advanceFocusIfTextboxFilled() {
        switch currentFocus {
        case .hourDigit1:
            if hourDigit1.count == 1 { currentFocus = .minuteDigit1 }
        case .minuteDigit1:
            if minuteDigit1.count == 1 { currentFocus = .minuteDigit2 }
        case .minuteDigit2:
            if minuteDigit2.count == 1 {
                if allFieldsFilled {
                    withAnimation(.spring) {
                        updateBindingsFromInput()
                    }
                }
            }
        case .none:
            break
        }
    }

    /// Moves focus one field to the right, if possible.
    private func advanceFocus() {
        switch currentFocus {
        case .hourDigit1:
            currentFocus = .minuteDigit1
        case .minuteDigit1:
            currentFocus = .minuteDigit2
        case .minuteDigit2:
            break
        case .none:
            break
        }
    }
    
    /// Moves focus one field to the left, if possible.
    private func retreatFocus() {
        switch currentFocus {
        case .hourDigit1:
            break
        case .minuteDigit1:
            currentFocus = .hourDigit1
        case .minuteDigit2:
            currentFocus = .minuteDigit1
        case .none:
            break
        }
    }

    /// Computes hour, minute, and derived lives from the three digit fields.
    /// Returns `nil` if any field is invalid or minutes are out of range (0...59).
    private func computeOutput() -> (hour: Int, minute: Int, lives: Int)? {
        guard
            let h = Int(hourDigit1),
            let m1 = Int(minuteDigit1),
            let m2 = Int(minuteDigit2)
        else { return nil }

        let minuteValue = m1 * 10 + m2
        guard (0...59).contains(minuteValue) else { return nil }

        let totalMinutes = h * 60 + minuteValue
        let lives = max(1, (totalMinutes / 10   ) + 1)
        return (h, minuteValue, lives)
    }

    /// Updates the bound `hours`, `minutes`, and `lives` from current input if valid.
    func updateBindingsFromInput() {
        if let computed = computeOutput() {
            hours = computed.hour
            minutes = computed.minute
            lives = computed.lives
        }
    }

}

#Preview {
    TimeInputView(hours: .constant(0), minutes: .constant(0), lives: .constant(0))
}
