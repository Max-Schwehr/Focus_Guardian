//
//  SessionClass.swift
//
//  Created by Maximiliaen Schwehr on 12/1/25.
//

import Foundation
import SwiftData

@Model
class FocusSession {
    var targetLength : Int
    var completed: Bool
    var date : Date
    var totalHeartsCount : Int
    
    init(targetLength: Int, completed: Bool, date: Date, totalLivesCount: Int) {
        self.targetLength = targetLength
        self.completed = completed
        self.date = date
        self.totalHeartsCount = totalLivesCount
    }
}

let mocSession : FocusSession = FocusSession(targetLength: 130, completed: false, date: Date(), totalLivesCount: 5)
extension FocusSession {
    /// Convenient factory for previews and tests
    static func mockSamples(now: Date = Date()) -> [FocusSession] {
        let calendar = Calendar.current
        return [
            FocusSession(targetLength: 25, completed: true,  date: now, totalLivesCount: 3),
            FocusSession(targetLength: 50, completed: false, date: calendar.date(byAdding: .minute, value: -40, to: now)!, totalLivesCount: 5),
            FocusSession(targetLength: 30, completed: true,  date: calendar.date(byAdding: .day, value: -1, to: now)!, totalLivesCount: 4),
            FocusSession(targetLength: 45, completed: false, date: calendar.date(byAdding: .day, value: -1, to: now)!, totalLivesCount: 2),
            FocusSession(targetLength: 20, completed: true,  date: calendar.date(byAdding: .day, value: -2, to: now)!, totalLivesCount: 3)
        ]
    }
}

