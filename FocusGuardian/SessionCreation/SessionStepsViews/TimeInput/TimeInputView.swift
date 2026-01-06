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
    @Binding var hours: Int
    @Binding var minutes: Int
    @Binding var lives: Int
    
    @State private var selectedID : Int = 0
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 14) {
            VStack(spacing: 6) {
                Text("Enter Focus Length")
                    .bold()
                    .font(.title3)
                
                Text("Hours and Minutes")
                    .foregroundStyle(.secondary)
                
                TimeInputBoxes(hours: $hours, minutes: $minutes, lives: $lives)
                
            }
            
            RoundedRectangle(cornerRadius: 3)
                .frame(width: 1.5, height: 18)
                .foregroundStyle(.secondary)
            
            ScrollViewReader { proxy in
                GeometryReader { geo in
                    let halfWidth = geo.size.width / 2
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            // Leading spacer so first items can be centered
                            Color.clear
                                .frame(width: halfWidth - 16)
                                .accessibilityHidden(true)

                            TimeInputSectionCell(isFocusSection: true, minutes: 60)
                                .id(0)
                                .onTapGesture {
                                    selectedID = 0
                                }
                            TimeInputSectionCell(isFocusSection: false, minutes: 30)
                                .id(1)
                                .onTapGesture {
                                    selectedID = 1
                                }
                            
                            // Trailing spacer so last items can be centered
                            Color.clear
                                .frame(width: halfWidth - 16)
                                .accessibilityHidden(true)
                        }
                        .padding(.horizontal, 16)
                    }
                    .safeAreaPadding(.horizontal, 0)
                    .onChange(of: selectedID) { _, newValue in
                        center(on: newValue, with: proxy)
                    }
                }
            }
            .frame(height: 50)
        }
    }
    // MARK: - Centering logic
    private func center(on id: Int, with proxy: ScrollViewProxy) {
        // Using .centered with anchor ensures the targeted item aligns to the center of the scroll view.
        withAnimation(.spring(response: 0.4, dampingFraction: 0.9)) {
            proxy.scrollTo(id, anchor: .center)
        }
    }
}

#Preview {
    TimeInputView(hours: .constant(0), minutes: .constant(0), lives: .constant(0))
        .frame(width: 500, height: 550)
        .background(Color.gray.opacity(0.1))
}
