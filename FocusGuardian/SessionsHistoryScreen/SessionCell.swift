//
//  SessionCell.swift
//  FocusGuardian
//
//  Created by Maximiliaen Schwehr on 12/22/25.
//

import SwiftUI

struct SessionCell: View {
    var session: FocusSession
    var body: some View {
        HStack {
            HStack {
                Image(systemName: session.completed ? "checkmark.circle" : "xmark.circle")
                VStack(alignment: .leading) {
                    HStack {
                        Text(session.completed ? "Session Completed" : "Session Failed")
                        Spacer()
                        Text("\(secondsToPresentableTime(seconds: session.targetLength * 60, showSeconds: false))")
                    }
                    Text("8:30 AM")
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                }
            }
            .padding(12)
        }
        .glassEffect(session.completed ? .regular.tint(.green.opacity(0.04)) : .regular.tint(.red.opacity(0.04)), in: .rect(cornerRadius: 16))
    }
}

#Preview {
    SessionCell(session: mocSession)
        .padding()
}
