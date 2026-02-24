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
    @Binding var length: Int?
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
                    .font(.headline)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .contentShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .buttonStyle(.plain)
            .glassEffect(.regular)
            .shadow(color: .black.opacity(0.15), radius: 12, y: 4)

            
            
            // MARK: - Add Break / Work Session
            // Quick action to add a break (or convert to work session later)
            Button {
                // If the list of sections is empty, create a new section based on the current values of `hours` and `minutes`
                if sections.isEmpty {
//                    sections.append(FocusSection(length: length, isFocusSection: true))
                }
                // Add the new break section
                sections.append(FocusSection(length: 0, isFocusSection: isAddingWorkSession))
                // Focus on the newly appended section
                selectedID += 1
                
                isAddingWorkSession.toggle()
            } label: {
                Label("\(isAddingWorkSession ? "Add Work Session" : "Add Break")", systemImage: "zzz")
                    .labelStyle(.titleAndIcon)
                    .font(.headline)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .contentShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .buttonStyle(.plain)
            .glassEffect(.regular)
            .shadow(color: .black.opacity(0.15), radius: 12, y: 4)

        }
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
    TimeInputButtonBar(sections: .constant([]), length: .constant(0), selectedID: .constant(0))
        .padding()

        .background(Color.gray.opacity(0.2))
}

