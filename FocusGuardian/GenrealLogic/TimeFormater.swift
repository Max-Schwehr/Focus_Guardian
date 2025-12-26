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
func secondsToPresentableTime(seconds: Int, showSeconds: Bool) -> String {
    let hours = seconds / 3600
    let minutes = (seconds % 3600) / 60
    let remainingSeconds = seconds % 60

    let underTenMinutes = seconds < 600
    let includeSeconds = underTenMinutes || showSeconds

    if underTenMinutes {
        // Show only minutes and seconds
        return "\(minutes)min\(includeSeconds ? ", \(remainingSeconds)sec" : "")"
    } else {
        // Show hours and minutes (and seconds if requested)
        return "\(hours)hr, \(minutes)min\(includeSeconds ? ", \(remainingSeconds)sec" : "")"
    }
}

