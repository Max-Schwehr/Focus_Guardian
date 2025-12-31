//
//  WebsiteBlockingView.swift
//  FocusGuardian
//
//  Created by Maximiliaen Schwehr on 12/30/25.
//


import SwiftUI
internal import System

struct WebsiteBlockingView: View {
    @State private var blockedWebsitesLocal: [String] = []
    @State private var textField: String = ""

    @State private var animatingID: String? = nil
    @Namespace private var ns

    var body: some View {
        VStack(spacing: 12) {
            Text("Enter a website to block")
                .padding(.top, 10)
                .bold()
                .onDisappear { blockedWebsites = blockedWebsitesLocal }

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
                        TextField("example.com", text: $textField)
                            .onSubmit { addWebsite() }
                            .font(.title2)
                            .bold()
                            .fontDesign(.monospaced)
                            .padding(10)
                            .glassEffect(in: .rect(cornerRadius: 16))
                            .frame(width: 300)

                        grid
                    }
                }
            }
        }
    }

    private var grid: some View {
        LazyVStack(alignment: .center, spacing: 12) {
            ForEach(Array(stride(from: 0, to: blockedWebsitesLocal.count, by: 2)), id: \.self) { index in
                HStack(alignment: .top, spacing: 15) {
                    cell(for: blockedWebsitesLocal[index])

                    if index + 1 < blockedWebsitesLocal.count {
                        cell(for: blockedWebsitesLocal[index + 1])
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
                blockedWebsitesLocal.append(newID)
            }

            // Phase 3: remove the SOURCE after the spring settles
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
                animatingID = nil
            }
        }
    }
}

#Preview {
    SessionCreationView(step: .contentBlockingInput)
        .frame(width: 517, height: 573)
}
