//
//  TimeFormater.swift
//  FocusGuardian
//
//  Created by Maximiliaen Schwehr on 12/6/25.
//

import Foundation
import Swift


/// Converts a number of minutes, and outputs that value as a string that has an hour value, and a minute value.
/// - Parameter minutes: Number of total minutes
/// - Returns: A string that has hour(s) and minute(s)
func minutesToHoursAndMinutes(seconds: Int, showSeconds: Bool) -> String {
    let hours : Int = seconds / 3600
    let minutes : Int = seconds % 60
    let seconds : Int = seconds % 3600
    return "\(hours)hr, \(minutes)min\(showSeconds ? ", \(seconds)sec" : "")"
}
