//
//  TimeFormater.swift
//  FocusGuardian
//
//  Created by Maximiliaen Schwehr on 12/6/25.
//

import Foundation
import Swift

/// Converts a number of seconds into a string showing hours, minutes, and optional seconds.
/// - Parameters:
///   - seconds: Total number of seconds
///   - showSeconds: Whether to include seconds in the output string
/// - Returns: A formatted string "Xhr, Ymin, Zsec"
func minutesToHoursAndMinutes(seconds: Int, showSeconds: Bool) -> String {
    let hours = seconds / 3600
    let minutes = (seconds % 3600) / 60
    let remainingSeconds = seconds % 60
    
    return "\(hours)hr, \(minutes)min\(showSeconds ? ", \(remainingSeconds)sec" : "")"
}

