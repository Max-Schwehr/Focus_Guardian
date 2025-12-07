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
    
    init(targetLength: Int, completed: Bool, date: Date) {
        self.targetLength = targetLength
        self.completed = completed
        self.date = date
    }
}
