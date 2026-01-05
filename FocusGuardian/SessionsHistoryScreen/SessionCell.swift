//
//  SessionCell.swift
//  FocusGuardian
//
//  Created by Maximiliaen Schwehr on 12/22/25.
//

import SwiftUI

struct SessionCell: View {
    init(session: FocusSession) {
        self.session = session
        _completionDetails = State(initialValue: getSessionCompletionDetails(session: session))
    }
    
    var session: FocusSession
    @State private var completionDetails: (isSessionCompleted: Bool, extraMinutesCompleted: Int)
    
    
    private func displaySectionRows() -> Bool {
        return session.sections.count > 1 || completionDetails.extraMinutesCompleted > 0
    }
    
    
    var body: some View {
        HStack {
            if session.sections.isEmpty {
                // MARK: -  Error case
                // Happens if the session object does not have any sections within it.
                
                Spacer()
                Text("Could not display session information")
                Spacer()
            } else {
                // MARK: - Normal Cell
                VStack(alignment: .leading, spacing: 4) {
                    // Title
                    Text("Session on \(formatDateToDayOfWeek(date: session.date))")
                        .bold()
 
                    // If there are multiple sections, find the total time the user spent working
                    if displaySectionRows() {
                        Text("Total Time You Spent Working: \(secondsToPresentableTime(seconds: session.completedLength * 60, showSeconds: false))")
                    }
                    
                    // Total Hearts Used
                    Text("Total Hearts Used: 2 out of 3 ")
                    
                    // Session Completion Status
                    HStack(spacing: 4) {
                        Text(completionDetails.isSessionCompleted ? "Session Completed" : "Session Not Completed")
                        
                        Image(systemName: completionDetails.isSessionCompleted ? "checkmark" : "xmark")
                        Spacer() // Push's cell to take up the max width possible
                    }
                    
                    // MARK: Section Cells
//                    if displaySectionRows() {
                        Divider()
                            .padding(.vertical, 4)
//                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        
                        Text("Session Schedule:")
                            .fontWeight(.medium)
                        
                        // List of Section Cells
                        ForEach(Array(session.sections.enumerated()), id: \.offset) { index, section in
                            SectionCell(
                                systemImage: section.isFocusSection ? "briefcase" : "bed.double",
                                title: section.isFocusSection ? "Work:" : "Break:",
                                timeText: secondsToPresentableTime(seconds: section.length * 60, showSeconds: false)
                            )
                        }
                        
                        // Display a section cell describing extra time the user worked, assuming the user worked extra time
                        if completionDetails.extraMinutesCompleted > 0 {
                            SectionCell(
                                systemImage: "ellipsis.circle",
                                title: "Add-on",
                                timeText: secondsToPresentableTime(seconds: completionDetails.extraMinutesCompleted * 60, showSeconds: false)
                            )
                        }
                    }
                    
                }
            }
        }
        .padding()
        .glassEffect(.regular.tint(completionDetails.isSessionCompleted ? Color.green.opacity(0.02) : Color.red.opacity(0.02)), in: .rect(cornerRadius: 15))
    }
}

#Preview("Complex completed") {
    SessionCell(session: FocusSession(completedLength: 130, date: Date(), totalHeartsCount: 3, problemOccurred: false, sections: [FocusSection(length: 50, isFocusSection: true), FocusSection(length: 10, isFocusSection: false), FocusSection(length: 50, isFocusSection: true)]))
        .padding()
        .background(.gray.opacity(0.1))
        .frame(width: 400)
}

#Preview("Simple uncompleted") {
    SessionCell(session: FocusSession(completedLength: 50, date: Date(), totalHeartsCount: 3, problemOccurred: false, sections: [FocusSection(length: 50, isFocusSection: true)]))
        .padding()
        .background(.gray.opacity(0.1))
        .frame(width: 400)
}
#Preview("Error") {
    SessionCell(session: FocusSession(completedLength: 50, date: Date(), totalHeartsCount: 3, problemOccurred: false, sections: []))
        .padding()
        .background(.gray.opacity(0.1))
        .frame(width: 400)
}



func formatDateToDayOfWeek(date: Date) -> String {
    let weekDay = date.formatted(.dateTime.weekday(.wide))
    let time = date.formatted(.dateTime.hour().minute())
    return weekDay + " at " + time
}


func getSessionCompletionDetails(session: FocusSession) -> (isSessionCompleted: Bool, extraMinutesCompleted: Int) {
    var targetWorkTime = 0
    for section in session.sections {
        if section.isFocusSection {
            targetWorkTime += section.length
        }
    }
    
    return ( session.completedLength >= targetWorkTime, max(0, session.completedLength - targetWorkTime))
}

