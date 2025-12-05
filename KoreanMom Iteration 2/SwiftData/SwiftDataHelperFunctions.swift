//
//  File.swift
//  KoreanMom Iteration 2
//
//  Created by Maximiliaen Schwehr on 12/2/25.
//

import Foundation
import SwiftUI
import SwiftData

enum CustomError: Error {
    case noValuesInList
}

/// Returns the Focus session that has the most recent date
/// - Parameter list: Input of `FocusSession`s to find the most recent from
/// - Returns: most recent `FocusSession` within the inputed list
func getMostRecentFocusSession(list: [FocusSession]) throws -> FocusSession {
    var sortedList = list
    print("COUNT: \(list.count)")
    sortedList.sort(by: { $0.date < $1.date })
    if let lastElement = sortedList.last {
        return lastElement
    }
    throw CustomError.noValuesInList
}
