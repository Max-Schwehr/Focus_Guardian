//
//  StandardTextInputView.swift
//  FocusGuardian
//
//  Created by Codex on 2/23/26.
//

import SwiftUI

struct StandardTextInputView: View {
    @Binding var text: String

    var placeholder: String = "Type here"
    var cornerRadius: CGFloat = 16
    var onSubmit: (() -> Void)? = nil

    var body: some View {
        ZStack {
            TextField(placeholder, text: $text)
                .onSubmit { onSubmit?() }
                .textFieldStyle(.plain)
                .padding()
                .background(.clear)
                .glassEffect(.clear)
                .font(.title3)
                .bold()
                .fontDesign(.monospaced)
        }
        .padding()
        .glassEffect()
    }
}

#Preview {
    @Previewable @State var text = ""

    StandardTextInputView(
        text: $text,
        placeholder: "example.com"
    )
    .padding()
    .background(Color(.systemGray).opacity(0.1))
}
