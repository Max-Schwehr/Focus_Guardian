//
//  TimeInputButtonBar.swift
//  FocusGuardian
//
//  Created by Maximiliaen Schwehr on 1/8/26.
//

import SwiftUI

// MARK: - TimeInputButtonBar
// Toolbar for adding sessions or using presets.
struct TimeInputButtonBar: View {
    @Binding var sections : [FocusSection]
    @Binding var hours : Int
    @Binding var minutes : Int
    var body: some View {
        HStack {
            // MARK: - Presets Menu
            Menu {
                Section("Pomodoro Timer Templates...") {
                    // Top-level presets list
                    ForEach(sessionPresets) { preset in
                        // Submenu: variants by number of work sessions
                        Divider()
                        SubMenu(preset: preset)
                    }
                }
            } label: {
                // MARK: Button Label
                Image(systemName: "ellipsis.circle")
                    .padding()
            }
            .buttonStyle(.plain)
            .glassEffect()
            
            
            // MARK: - Add Break / Work Session
            // Quick action to add a break (or convert to work session later)
            Button {
                if sections.isEmpty {
                    sections.append(FocusSection(length: hours * 60 + minutes, isFocusSection: true))
                    sections.append(FocusSection(length: 0, isFocusSection: false))
                }
            } label: {
                Label("Add Break", systemImage: "zzz")
                    .fontWeight(.medium)
                    .padding()
            }
            .buttonStyle(.plain)
            .glassEffect()
            .shadow(color: .black.opacity(0.15), radius: 12, y: 4)
        }
        .padding(12)
        
        // MARK: Outline around view
        .overlay(
            ZStack(alignment: .top) {
                let gapSpace = 0.26
                Text("Add Scheduled Breaks")
                    .font(.system(size: 10))
                    .frame(height: 10)
                    .offset(y: -5)
                
                ZStack {
                    // Left segment
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .trim(from: 0, to: 0.25 - (gapSpace / 2))
                        .stroke(Color.primary.opacity(0.25), lineWidth: 1)
                        .scaleEffect(x: 1, y: -1, anchor: .center)
                    // Left segment
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .trim(from: 0.5, to: 0.75 - (gapSpace / 2))
                        .stroke(Color.primary.opacity(0.25), lineWidth: 1)
                    // Bottom Segment
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .trim(from: 0, to: 0.5)
                        .stroke(Color.primary.opacity(0.25), lineWidth: 1)
                }
            }
        )
    }
}

// MARK: Submenu: Type of pomodoro timer, and its possible configurations
private struct SubMenu: View {
    var preset : SessionPreset
    var body: some View {
        Menu {
            Section("Select your \(preset.name)'s length...") {
                ForEach(1..<6) { index in
                    Divider()
                    Button {
                        // TODO: Handle selecting this preset variant
                    } label: {
                        let totalTime = generateFocusSectionsFromPreset(sessionPreset: preset.function, numberOfWorkSessions: index).totalLength * 60 // Should be in minutes, thus to use of `* 60`
                        let totalTimeString = "Total Time: \(secondsToPresentableTime(seconds: totalTime, showSeconds: false))"
                        Text("\(index) work sessions + \(index - 1) breaks. \n\(totalTimeString)")
                    }
                }
            }
        } label: {
            Text(preset.name)
            Text(preset.description)
        }
    }
}

#Preview {
    TimeInputButtonBar(sections: .constant([]), hours: .constant(0), minutes: .constant(0))
        .padding()
}

