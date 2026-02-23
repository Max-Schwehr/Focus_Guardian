//
//  AppCell.swift
//  FocusGuardian
//
//  Created by Maximiliaen Schwehr on 1/1/26.
//
import SwiftUI
import AppKit

struct AppCell: View {
    static let size = CGSize(width: 108, height: 128)
    @Binding var isSelected: Bool
    let icon: NSImage
    let title: String

    var body: some View {
        VStack(spacing: 10) {
            Image(nsImage: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)

            Text(title)
                .font(.body)
                .bold()
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.9)
                .frame(maxWidth: .infinity, minHeight: 34, alignment: .top)
        }
        .padding(10)
        .frame(width: Self.size.width, height: Self.size.height, alignment: .top)
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
