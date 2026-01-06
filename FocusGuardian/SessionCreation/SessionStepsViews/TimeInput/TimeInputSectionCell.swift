//
//  TimeInputSectionCell.swift
//  FocusGuardian
//
//  Created by Maximiliaen Schwehr on 1/5/26.
//

import SwiftUI

struct TimeInputSectionCell: View {
    var isFocusSection : Bool // Determines if it is a break section, or focus section.
    var minutes : Int
    var body: some View {
        VStack(spacing: -1) {
            Text(secondsToPresentableTime(seconds: minutes * 60, showSeconds: false))
                .fontWeight(.medium)
            Text(isFocusSection ? "Work" : "Break")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 5)
        .frame(width: isFocusSection ? 100 : 90)
        .foregroundStyle(isFocusSection ? .white : .black)
        .glassEffect(.clear.tint(isFocusSection ? .blue : .clear), in: .rect(cornerRadius: 16))
    }
}

#Preview("Work Section Cell") {
    TimeInputSectionCell(isFocusSection: true, minutes: 90)
        .padding()
}

#Preview("Break Section Cell") {
    TimeInputSectionCell(isFocusSection: false, minutes: 20)
        .padding()
}
