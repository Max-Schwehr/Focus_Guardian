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
        let corner: CGFloat = 16
        let gradient = LinearGradient(
            colors: session.completed
                ? [Color.green.opacity(0.35), Color.green.opacity(0.12)]
                : [Color.red.opacity(0.35), Color.red.opacity(0.12)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

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
        .background(
            ZStack {
                // Subtle tint under the glass to feel like part of the material
                RoundedRectangle(cornerRadius: corner, style: .continuous)
                    .fill(gradient)
//                    .blendMode(.multiply)
                    .opacity(1.0)

                // A faint inner highlight for depth
                RoundedRectangle(cornerRadius: corner, style: .continuous)
                    .strokeBorder(.white.opacity(0.4))
//                    .blendMode(.screen)
            }
        )

        .glassEffect(.clear.interactive(), in: .rect(cornerRadius: corner))
        .contentShape(RoundedRectangle(cornerRadius: corner, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: corner, style: .continuous)
                .strokeBorder(.white.opacity(0.08))
        )
        .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 4)
        .listRowInsets(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0))
        .listRowBackground(Color.clear)
    }
}

#Preview {
    SessionCell(session: mocSession)
        .frame(width: 400)
        .padding()
}
