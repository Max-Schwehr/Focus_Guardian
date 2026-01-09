//
//  TimeInputButtonBar.swift
//  FocusGuardian
//
//  Created by Maximiliaen Schwehr on 1/8/26.
//

import SwiftUI

// THE ADD BREAK/WORK SESSION, or USE TEMPLATE button for using section cells
struct TimeInputButtonBar: View {
    var body: some View {
        HStack {
            // MARK: - Presets Button
            Menu {

                ForEach(sessionPresets) { preset in
                    Menu {
                        Text("Select length for \(preset.name)")
                        ForEach(1..<6) { index in
                            Button {
                                
                            } label: {
                                Text("\(index) work sessions + \(index - 1) breaks")
                            }
                        }
                    } label: {
                        Button {
                            
                        } label: {
                            Text(preset.name)
                            Text(preset.description)
                        }
                    }
                    Divider()
                }
            } label: {
                Label("Presets", systemImage: "list.bullet")
                    .padding()
            }
            .buttonStyle(.plain)
            .glassEffect()
            
            // MARK: - Add Break / Work Session Button
            Button {
                
            } label: {
                Label("Add Break", systemImage: "zzz")
                    .fontWeight(.medium)
                    .padding()
            }
            .buttonStyle(.plain)
            .glassEffect()
            .shadow(color: .black.opacity(0.15), radius: 12, y: 4)
        }
    }
}

#Preview {
    TimeInputButtonBar()
    .padding()
}
