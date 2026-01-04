//
//  SessionClass.swift
//
//  Created by Maximiliaen Schwehr on 12/1/25.
//

import Foundation
import SwiftData

@Model
class FocusSession {
    var completedLength : Int
    var date : Date
    var totalHeartsCount : Int
    var problemOccurred : Bool
    var sections = [FocusSection]()
    
    init(completedLength: Int, date: Date, totalHeartsCount: Int, problemOccurred: Bool, sections: [FocusSection] = [FocusSection]()) {
        self.completedLength = completedLength
        self.date = date
        self.totalHeartsCount = totalHeartsCount
        self.problemOccurred = problemOccurred
        self.sections = sections
    }
}

@Model
class FocusSection {
    var length : Int
    var isFocusSection : Bool // Focus Section or Break Section
    
    init(length: Int, isFocusSection: Bool) {
        self.length = length
        self.isFocusSection = isFocusSection
    }
}

//let mocSession : FocusSession = FocusSession(targetLength: 130, completed: false, date: Date(), totalLivesCount: 5)
//extension FocusSession {
//    /// Convenient factory for previews and tests
//    static func mockSamples(now: Date = Date()) -> [FocusSession] {
//        let calendar = Calendar.current
//        return [
//            FocusSession(targetLength: 25, completed: true,  date: now, totalLivesCount: 3),
//            FocusSession(targetLength: 50, completed: false, date: calendar.date(byAdding: .minute, value: -40, to: now)!, totalLivesCount: 5),
//            FocusSession(targetLength: 30, completed: true,  date: calendar.date(byAdding: .day, value: -1, to: now)!, totalLivesCount: 4),
//            FocusSession(targetLength: 45, completed: false, date: calendar.date(byAdding: .day, value: -1, to: now)!, totalLivesCount: 2),
//            FocusSession(targetLength: 20, completed: true,  date: calendar.date(byAdding: .day, value: -2, to: now)!, totalLivesCount: 3)
//        ]
//    }
//}

