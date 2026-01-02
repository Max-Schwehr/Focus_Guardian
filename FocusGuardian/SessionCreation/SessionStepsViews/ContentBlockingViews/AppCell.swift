//
//  AppCell.swift
//  FocusGuardian
//
//  Created by Maximiliaen Schwehr on 1/1/26.
//
import SwiftUI
import AppKit

struct AppCell: View {
    @Binding var isSelected: Bool
    let icon: NSImage
    let title: String
    var body: some View {
        VStack(spacing: 2) {
            Image(nsImage: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
            Text(title)
                .font(.body)
                .bold()
                .multilineTextAlignment(.center)
        }
        .padding(8)
        .frame(width: 80)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(isSelected ? Color.accentColor.opacity(0.15) : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(isSelected ? Color.accentColor : Color.secondary.opacity(0.2), lineWidth: isSelected ? 2 : 1)
        )
        .onTapGesture {
            withAnimation {
                isSelected.toggle()
            }
        }
    }
}

#Preview("Safari") {
    @Previewable @State var selected = true
    let safariURL = URL(fileURLWithPath: "/Applications/Safari.app")
    let safariIcon = NSWorkspace.shared.icon(forFile: safariURL.path)
    return AppCell(isSelected: $selected, icon: safariIcon, title: "Safari")
        .padding()
}

#Preview("Crome") {
    @Previewable @State var selected = true
    let safariURL = URL(fileURLWithPath: "/Applications/Safari.app")
    let safariIcon = NSWorkspace.shared.icon(forFile: safariURL.path)
    return AppCell(isSelected: $selected, icon: safariIcon, title: "Google Crome")
        .padding()
}
