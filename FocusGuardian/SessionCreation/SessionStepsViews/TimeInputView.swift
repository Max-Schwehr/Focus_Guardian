//
//  TimeInputView.swift
//
//  Created by Maximiliaen Schwehr on 11/7/25.
//

import SwiftUI

/// Identifies which single-character digit field currently has focus.
enum CurrentDigitFocus: Hashable {
    case hourDigit1
    case minuteDigit1
    case minuteDigit2
}

struct TimeInputView: View {
    // Bindings for output values
    @Binding var length : Int?
    @Binding var lives: Int?
    @State private var selectedID : Int = 0 // This represent which view the scroll view should scroll to
    @Binding var sections : [FocusSection]
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 14) {
            Spacer()
            // MARK: - Time Input Boxes
            TimeInputBoxes(length: $length, lives: $lives)
                .onChange(of: length) { old, new in
                    // Handle the user finishing typing in the minutes and hours by adding or editing a section in the `sections` list
                    guard let new else { return }
                    print("USER DONE TYPING")
                    if sections.isEmpty {
                        sections.append(FocusSection(length: new, isFocusSection: true))
                    } else {
                        sections[selectedID].length = new
                    }
                }
                .onAppear {
                    syncLengthFromSelectedSection()
                }
            
            if sections.count > 1 {
                // MARK: - Vertical Divider
                RoundedRectangle(cornerRadius: 3)
                    .frame(width: 1.5, height: 18)
                    .foregroundStyle(.secondary)
                
                
                // MARK: - Horizontal Scroll View Section Cells
                ScrollViewReader { proxy in
                    GeometryReader { geo in
                        let halfWidth = geo.size.width / 2
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                // Leading spacer so first items can be centered
                                Color.clear
                                    .frame(width: halfWidth - 16)
                                    .accessibilityHidden(true)
                                
                                // For each item in the sections list
                                ForEach(sections.indices, id: \.self) { index in
                                    let section = sections[index]
                                    TimeInputSectionCell(isFocusSection: section.isFocusSection, minutes: section.length)
                                        .onTapGesture {
                                            selectedID = index
                                            syncLengthFromSelectedSection()
                                        }
                                        .id(index)
                                }
                                
                                // Trailing spacer so last items can be centered
                                Color.clear
                                    .frame(width: halfWidth - 16)
                                    .accessibilityHidden(true)
                            }
                            .padding(.horizontal, 16)
                        }
                        .safeAreaPadding(.horizontal, 0)
                        // Portion that runs the logic to center a Section Cell
                        .onAppear {
                            center(on: selectedID, with: proxy)
                        }
                    }
                }
                .frame(height: 50)
            }
            
            Spacer()
        }
    }
    // MARK: - Centering logic
    private func center(on id: Int, with proxy: ScrollViewProxy) {
        // Using .centered with anchor ensures the targeted item aligns to the center of the scroll view.
        withAnimation(.spring(response: 0.4, dampingFraction: 0.9)) {
            proxy.scrollTo(id, anchor: .center)
        }
    }

    private func syncLengthFromSelectedSection() {
        guard sections.indices.contains(selectedID) else { return }
        length = sections[selectedID].length
    }
}

#Preview("With Sections") {
    TimeInputView(length: .constant(50), lives: .constant(0), sections: .constant([
        FocusSection(length: 50, isFocusSection: true),
        FocusSection(length: 10, isFocusSection: false),
        FocusSection(length: 50, isFocusSection: true)
        
    ]))
    .padding()
    
    .frame(width: 500, height: 550)
    .background(Color.gray.opacity(0.1))
}

#Preview("No Sections") {
    TimeInputView(length: .constant(nil), lives: .constant(0), sections: .constant([]))
        .padding()
    
        .frame(width: 500, height: 550)
        .background(Color.gray.opacity(0.1))
}
