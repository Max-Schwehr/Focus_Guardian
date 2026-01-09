//
//  GlassSegmentedPicker.swift
//  FocusGuardian
//
//  Created by Maximiliaen Schwehr on 1/2/26.
//

import SwiftUI

struct GlassSegmentedPicker: View {
    @Binding var isWebSelected: Bool
    private let segmentSpacing: CGFloat = 8
    private let backgroundOutset: CGFloat = 4

    init(isWebSelected: Binding<Bool>) {
        self._isWebSelected = isWebSelected
    }

    var body: some View {
        // Segmented control with intrinsic-width segments and a single sliding background
        ZStack(alignment: .leading) {
            // Labels and tap targets
            HStack(spacing: segmentSpacing) {
                // Web segment
                Button {
                    // Animate selection change for smooth slide
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.95)) {
                        isWebSelected = true
                    }
                } label: {
                    Text("Block Websites")
                        .fontWeight(isWebSelected ? .bold : .regular)
                        .foregroundStyle(isWebSelected ? Color.white : .primary)
                        .padding(.horizontal, 12)
                        .frame(maxHeight: .infinity)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                // Report bounds for background positioning
                .anchorPreference(key: SegmentBoundsPreference.self, value: .bounds) { ["web": $0] }
                
                // Apps segment
                Button {
                    // Animate selection change for smooth slide
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.95)) {
                        isWebSelected = false
                    }
                } label: {
                    Text("Block Apps")
                        .fontWeight(!isWebSelected ? .bold : .regular)
                        .foregroundStyle(!isWebSelected ? Color.white : .primary)
                        .padding(.horizontal, 12)
                        .frame(maxHeight: .infinity)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                // Report bounds for background positioning
                .anchorPreference(key: SegmentBoundsPreference.self, value: .bounds) { ["apps": $0] }
            }
        }
        // .frame(height: 40) // Fixed control height (deleted as per instructions)
        .padding(9)
        // Draw the moving background behind the labels using the reported bounds
        .backgroundPreferenceValue(SegmentBoundsPreference.self) { prefs in
            GeometryReader { proxy in
                let key = isWebSelected ? "web" : "apps"
                if let anchor = prefs[key] {
                    let rect = proxy[anchor]
                    ConcentricRectangle()
                        .foregroundStyle(.clear)
                        .glassEffect(.clear.tint(.accentColor))
                        .frame(width: rect.width + backgroundOutset * 2, height: rect.height + backgroundOutset * 2)
                        .position(x: rect.midX, y: rect.midY)
                        .animation(.spring(response: 0.25, dampingFraction: 0.95), value: isWebSelected)
                        .allowsHitTesting(false)
                }
            }
        }
        .glassEffect()
    }
}

private struct SegmentBoundsPreference: PreferenceKey {
    static var defaultValue: [String: Anchor<CGRect>] = [:]
    static func reduce(value: inout [String: Anchor<CGRect>], nextValue: () -> [String: Anchor<CGRect>]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

#Preview {
    GlassSegmentedPicker(isWebSelected: .constant(true))
        .frame(height: 30)
        .padding()
        
}

