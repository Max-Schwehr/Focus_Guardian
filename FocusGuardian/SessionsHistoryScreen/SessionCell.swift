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
    
    var body: some View {
        
        
        HStack {
            if session.sections.isEmpty {
                Spacer()
                Text("Could not display session information")
                Spacer()
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Session on \(formatDateToDayOfWeek(date: session.date))")
                        .bold()
                    if (session.sections.count > 1 || completionDetails.extraMinutesCompleted > 0) {
                        Text("Total Time Spent Working: \(secondsToPresentableTime(seconds: session.completedLength * 60, showSeconds: false))")
                    }
                    
                    Text("Total Hearts Used: 2 out of 3 ")
                    
                    HStack(spacing: 4) {
                        Text(completionDetails.isSessionCompleted ? "Session Completed" : "Session Not Completed")
                        Image(systemName: completionDetails.isSessionCompleted ? "checkmark" : "xmark")
                    }
                    .padding(.bottom, 8)
                    
                    Divider()
                    
                    
                    if session.sections.count > 1 || completionDetails.extraMinutesCompleted > 0 {
                        
                        Text("Session Schedule:")
                            .fontWeight(.medium)
                            .padding(.bottom, 4)
                        
                        VStack(spacing: 10) {
                            ForEach(Array(session.sections.enumerated()), id: \.offset) { index, section in
                                SessionRow(
                                    systemImage: section.isFocusSection ? "briefcase" : "bed.double",
                                    title: section.isFocusSection ? "Work:" : "Break:",
                                    timeText: secondsToPresentableTime(seconds: section.length * 60, showSeconds: false)
                                )
                            }
                            
                            if completionDetails.extraMinutesCompleted > 0 {
                                
                                SessionRow(
                                    systemImage: "ellipsis.circle",
                                    title: "Add-on",
                                    timeText: secondsToPresentableTime(seconds: completionDetails.extraMinutesCompleted * 60, showSeconds: false)
                                )
                            }
                        }
                    }
                    
                    if !(session.sections.count > 1 || completionDetails.extraMinutesCompleted > 0) {
                        Text("\(secondsToPresentableTime(seconds: session.completedLength * 60, showSeconds: false)) completed out of \(secondsToPresentableTime(seconds: session.sections[0].length * 60, showSeconds: false))")
                            .fontWeight(.medium)
                    }
                }
            }
        }
        .padding()
        .glassEffect(.regular.tint(completionDetails.isSessionCompleted ? Color.green.opacity(0.05) : Color.red.opacity(0.05)), in: .rect(cornerRadius: 15))
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

