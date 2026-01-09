//
//  SessionPresets.swift
//  FocusGuardian
//
//  Created by Maximiliaen Schwehr on 1/8/26.
//

import Foundation

enum SessionPresetFunction {
    case classicPomodoro
    case heroPomodoro
    case MBAStylePomodoro
}

struct SessionPreset: Identifiable, Hashable {
    var name : String
    var description : String
    var function : SessionPresetFunction
    var id = UUID()
}


let sessionPresets : [SessionPreset] = [
    SessionPreset(name: "Classic Pomodoro", description: "25-Minute Sessions, with 5-Minute Breaks. Every 4 work sessions a 30 Minute break is taken.", function: .classicPomodoro),
    SessionPreset(name: "Hero Pomodoro", description: "50-Minute work sessions, with 10-Minute Breaks. Considered the new Pomodoro standard.", function: .heroPomodoro),
    SessionPreset(name: "MBA Style Pomodoro", description: "60-Minute work sessions, with 15-Minute Breaks.", function: .MBAStylePomodoro)
]


/// Generates a list of `FocusSection`s based on the sessionPreset.
/// - Parameters:
///   - sessionPreset: The type of Session to use, example: `.classicPomodoro` or `.heroPomodoro`
///   - numberOfWorkSessions: The number of work sessions the user set, influencing how many breaks and work sessions the function will create.
/// - Returns: A list of work Sessions and Breaks.
func generateFocusSectionsFromPreset(sessionPreset: SessionPresetFunction, numberOfWorkSessions: Int) -> (focusSections: [FocusSection], totalLength: Int) {
    var focusSections: [FocusSection] = []
    var totalLength: Int = 0 // Total Length in Minutes
    
    guard numberOfWorkSessions > 0 else { return ([], 0)}
    
    switch sessionPreset {
    case .classicPomodoro:  // MARK: Classic Pomodoro Logic
        // for loop, code complete pls do
        for index in 1...numberOfWorkSessions {
            focusSections.append(FocusSection(length: 25, isFocusSection: true))
            totalLength += 25
            
            if index % 4 == 0 { // Every 4 work sessions, do a 30-Minute break instead of 5-Minute
                focusSections.append(FocusSection(length: 30, isFocusSection: false))
                totalLength += 30
            } else {
                focusSections.append(FocusSection(length: 5, isFocusSection: false))
                totalLength += 5
            }
        }
        
    case .heroPomodoro: // MARK: Hero Pomodoro Logic
        for _ in 1...numberOfWorkSessions {
            focusSections.append(FocusSection(length: 50, isFocusSection: true))
            focusSections.append(FocusSection(length: 10, isFocusSection: false))
            totalLength += 60
        }
        
    case .MBAStylePomodoro: // MARK: MBA Style Pomodoro Logic
        for _ in 1...numberOfWorkSessions {
            focusSections.append(FocusSection(length: 60, isFocusSection: true))
            focusSections.append(FocusSection(length: 15, isFocusSection: false))
            totalLength += 75
        }
    }
        
    // If the last section is a break, then remove it as its unneeded
    if focusSections.last?.isFocusSection == false {
        totalLength -= focusSections.last!.length
        focusSections.removeLast()
    }
    return (focusSections, totalLength)
}
