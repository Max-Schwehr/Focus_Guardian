//
//  TimeInputView.swift
//  KoreanMom Iteration 2
//
//  Created by Maximiliaen Schwehr on 11/7/25.
//

import SwiftUI

// Focus for each digit field
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

    // MARK: - Helpers
    private func advanceFocusIfNeeded() {
        switch currentFocus {
        case .hourDigit1:
            if hourDigit1.count == 1 { currentFocus = .minuteDigit1 }
        case .minuteDigit1:
            if minuteDigit1.count == 1 { currentFocus = .minuteDigit2 }
        case .minuteDigit2:
            if minuteDigit2.count == 1 {
                currentFocus = nil
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

    private func computeOutput() -> (hour: Int, minute: Int, lives: Int)? {
        guard
            let h = Int(hourDigit1),
            let m1 = Int(minuteDigit1),
            let m2 = Int(minuteDigit2)
        else { return nil }

        let minuteValue = m1 * 10 + m2
        guard (0...59).contains(minuteValue) else { return nil }

        let totalMinutes = h * 60 + minuteValue
        let lives = max(1, (totalMinutes / 8) + 1)
        return (h, minuteValue, lives)
    }

    func updateBindingsFromInput() {
        if let computed = computeOutput() {
            hours = computed.hour
            minutes = computed.minute
            lives = computed.lives
        }
    }

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
                        advanceFocusIfNeeded()
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
                        advanceFocusIfNeeded()
                    }
                    .submitLabel(.next)
                
                DigitInputView(input: $minuteDigit2)
                    .focused($currentFocus, equals: .minuteDigit2)
                    .onChange(of: minuteDigit2) { _, newValue in
                        let sanitized = sanitizeToSingleDigit(newValue)
                        let sanitizedString = String(sanitized)
                        if sanitizedString != minuteDigit2 { minuteDigit2 = sanitizedString }
                        advanceFocusIfNeeded()
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
        }
        .onDisappear {
            updateBindingsFromInput()
        }
    }
}

#Preview {
    TimeInputView(hours: .constant(0), minutes: .constant(0), lives: .constant(0))
}
