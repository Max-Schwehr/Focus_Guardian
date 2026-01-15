//
//  FocusGuardianTests.swift
//  FocusGuardianTests
//
//  Created by Maximiliaen Schwehr on 1/13/26.
//

import Testing
@testable import FocusGuardian


@Test("Test SanitizeToSingleDigit Function") func testSanitizeToSingleDigit() {
    let outputtedValue = sanitizeToSingleDigit(oldValue: "3", newValue: "23")
    #expect(outputtedValue == 2)
    
    let outputtedValue2 = sanitizeToSingleDigit(oldValue: "3", newValue: "4")
    #expect(outputtedValue2 == 4)
    
    let outputtedValue3 = sanitizeToSingleDigit(oldValue: "", newValue: "2")
    #expect(outputtedValue3 == 2)
    
    let outputtedValue4 = sanitizeToSingleDigit(oldValue: "", newValue: "f")
    #expect(outputtedValue4 == nil)
    
    let outputtedValue5 = sanitizeToSingleDigit(oldValue: "5", newValue: "56")
    #expect(outputtedValue5 == 6)
    
    
    let outputtedValue7 = sanitizeToSingleDigit(oldValue: "9", newValue: "99")
    #expect(outputtedValue7 == 9)
    
    let outputtedValue6 = sanitizeToSingleDigit(oldValue: "9", newValue: "99")
    #expect(outputtedValue6 == 9)
    
}
