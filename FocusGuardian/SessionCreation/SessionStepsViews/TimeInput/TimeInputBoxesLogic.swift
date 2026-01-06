//
//  TimeInputBoxesLogic.swift
//  FocusGuardian
//
//  Created by Maximiliaen Schwehr on 1/5/26.
//

import Foundation
import SwiftUI



extension TimeInputBoxes {
    /// Identifies which single-character digit field currently has focus.
    enum CurrentDigitFocus: Hashable {
        case hourDigit1
        case minuteDigit1
        case minuteDigit2
    }
    
    /// Advances focus to the next field when the current one has a single character.
    /// When the last field is filled and all fields are valid, updates bound values.
    func advanceFocusIfTextboxFilled() {
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
    func advanceFocus() {
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
    func retreatFocus() {
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
    func computeOutput() -> (hour: Int, minute: Int, lives: Int)? {
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
