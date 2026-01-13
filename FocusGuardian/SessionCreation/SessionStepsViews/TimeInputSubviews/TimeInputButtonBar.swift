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
    @Binding var selectedID : Int
    @State private var isAddingWorkSession : Bool = false
    var body: some View {
        HStack {
            // MARK: - Presets Menu
            Menu {
                Section("Pomodoro Timer Templates...") {
                    // Top-level presets list
                    ForEach(sessionPresets) { preset in
                        // Submenu: variants by number of work sessions
                        Divider()
                        SubMenu(preset: preset, sections: $sections)
                    }
                }
            } label: {
                // MARK: Button Label
                Image(systemName: "ellipsis.circle")
                    .padding()
            }
            .buttonStyle(.plain)
            .glassEffect(.clear)
            
            
            // MARK: - Add Break / Work Session
            // Quick action to add a break (or convert to work session later)
            Button {
                // If the list of sections is empty, create a new section based on the current values of `hours` and `minutes`
                if sections.isEmpty {
                    sections.append(FocusSection(length: hours * 60 + minutes, isFocusSection: true))
                }
                // Add the new break section
                sections.append(FocusSection(length: 0, isFocusSection: isAddingWorkSession))
                // Focus on the newly appended section
                selectedID += 1
                
                isAddingWorkSession.toggle()
            } label: {
                Label("\(isAddingWorkSession ? "Add Work Session" : "Add Break")", systemImage: "zzz")
                    .fontWeight(.medium)
                    .padding()
            }
            .buttonStyle(.plain)
            .glassEffect(.clear)
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
    @Binding var sections : [FocusSection]
    @State private var showingAlert = false
    var body: some View {
        Menu {
            Section("Select your \(preset.name)'s length...") {
                ForEach(1..<6) { index in
                    Divider()
                    Button {
                        // Add the generated sections to the `section` variable
                        if sections.count > 1 {
                            // If there is already content in the `sections` variable show this before over righting it
                            showingAlert = true
                            print("showingAlert: \(showingAlert)")
                        } else {
                            sections = generateFocusSectionsFromPreset(sessionPreset: preset.function, numberOfWorkSessions: index).focusSections
                            
                        }
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
        .alert("Overide Previews Content?", isPresented: $showingAlert) {
            Button("OK", role: .confirm) {
                sections = generateFocusSectionsFromPreset(sessionPreset: preset.function, numberOfWorkSessions: 2).focusSections
            }
            Button("No", role: .cancel) {
                
            }
        } message: {
            Text("You have already added breaks and work sections, do you want delete them, and add this template instead?")
        }
    }
}

#Preview {
    TimeInputButtonBar(sections: .constant([]), hours: .constant(0), minutes: .constant(0), selectedID: .constant(0))
        .padding()

        .background(Color.gray.opacity(0.2))
}

