//
//  WebsiteBlockingView.swift
//  FocusGuardian
//
//  Created by Maximiliaen Schwehr on 12/30/25.
//


import SwiftUI
internal import System

struct WebsiteBlockingView: View {
    @Binding var blockedWebsites: [String]
    @State private var textField: String = ""

    @State private var animatingID: String? = nil
    @Namespace private var ns

    var body: some View {
        VStack(spacing: 12) {
            VStack(spacing: 6) {
                Text("Type a website to block")
                    .bold()
                    .font(.title3)
                    

                Text("Websites blocked on: Safari, Chrome, Arc.\nClick return key to add website.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
            }
            GlassEffectContainer {
                ZStack(alignment: .top) {
                    // SOURCE (the one that "flies from" the TextField area)
                    if let id = animatingID {
                        WebsiteCell(url: id)
                            .matchedGeometryEffect(id: id, in: ns)
                            .zIndex(10)
                            .padding(.top, 0) // keep it visually in the TextField area
                    }

                    VStack(spacing: 12) {
                        StandardTextInputView(
                            text: $textField,
                            placeholder: "example.com",
                            onSubmit: addWebsite
                        )
                        .frame(width: 350)

                        grid
                    }
                }
            }
        }
    }

    private var grid: some View {
        LazyVStack(alignment: .center, spacing: 12) {
            ForEach(Array(stride(from: 0, to: blockedWebsites.count, by: 2)), id: \.self) { index in
                HStack(alignment: .top, spacing: 15) {
                    cell(for: blockedWebsites[index])

                    if index + 1 < blockedWebsites.count {
                        cell(for: blockedWebsites[index + 1])
                    }
                }
            }
        }
        .frame(width: 300)
    }

    private func cell(for url: String) -> some View {
        WebsiteCell(url: url)
            .matchedGeometryEffect(id: url, in: ns)   // DESTINATION
            .opacity(animatingID == url ? 0 : 1)      // hide destination while flying
    }

    private func addWebsite() {
        let trimmed = textField.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let newID = trimmed
        textField = ""

        // Phase 1: show the SOURCE first (no grid insert yet)
        animatingID = newID

        // Phase 2: next tick, insert the DESTINATION with animation
        DispatchQueue.main.async {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
                blockedWebsites.append(newID)
            }

            // Phase 3: remove the SOURCE after the spring settles
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
                animatingID = nil
            }
        }
    }
}

#Preview {
    WebsiteBlockingView(blockedWebsites: .constant(["example.com", "youtube.com"]))
        .frame(width: 517, height: 573)
}
