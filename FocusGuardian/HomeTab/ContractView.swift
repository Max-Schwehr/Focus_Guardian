//
//  ContractView.swift
//
//  Created by Maximiliaen Schwehr on 11/8/25.
//

import SwiftUI

struct ContractView: View {
    
    @Binding var isRetypeValid: Bool?
    
    var firstName = "Max"
    var lastName = "Schwehr"
    var contractSentencesList = [
        "I {FIRST} {LAST}, have cleaned my desk, got water, and I agree to LOCK IN!",
        "I {FIRST} {LAST}, agree to work the full length of the timer, with no breaks, or die trying!",
        "I {FIRST} {LAST}, hereby silence my phone, and will resist the siren song of Instagram!",
        "I {FIRST} {LAST}, am ready to work, and I will not stop or take breaks until the timer finishes!",
        "“I {FIRST} {LAST}, have entered Focus Mode. I will not stop for anything, until I return victorious"
    ]
    
    func getRandomSentence() -> String {
        var sentence = contractSentencesList.randomElement()!
        sentence.replace("{FIRST}", with: firstName)
        sentence.replace("{LAST}", with: lastName)
        return sentence

    }
    
    @State private var randomSentence = ""
    @State private var signatureText = ""
    @FocusState private var isSignatureFocused: Bool
    
    var body: some View {
        VStack (spacing: 20) {
            VStack(spacing: 6) {
                Text("Sign Focus Contract")
                    .bold()
                    .font(.title3)
                
                Text("Retype the following text...")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
            }
            
            Text(randomSentence)
                .bold()
                .fontDesign(.monospaced)
                .frame(width: 300)
                .multilineTextAlignment(.center)
                .onAppear {
                    randomSentence = getRandomSentence()
                    isSignatureFocused = true
                }
                
            TextField("Retyped Version", text: $signatureText)
                .disableAutocorrection(true)
                .font(.body.monospaced())
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color(.white))
                        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .strokeBorder(
                            {
                                switch isRetypeValid {
                                case .some(true): return Color.green.opacity(0.6)
                                case .some(false): return Color.red.opacity(0.5)
                                case .none: return Color.secondary.opacity(0.2)
                                }
                            }(),
                            lineWidth: 1
                        )
                )
                .focused($isSignatureFocused)
                .onChange(of: signatureText) { _, _ in
                    isRetypeValid = nil
                    let currentText = signatureText
                    Task { @MainActor in
                        try? await Task.sleep(nanoseconds: 1_000_000_000)
                        guard currentText == signatureText else { return }
                        print("CHECKING IF VALID OR NOT")
                        let isValid = await isValidRetype(phraseToBeTyped: randomSentence, phraseTyped: signatureText)
                        isRetypeValid = isValid
                    }
                }
            
            if isRetypeValid == false {
                HStack(spacing: 10) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.yellow)
                    Text("Please try retyping text again!")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    Spacer(minLength: 8)
                    Button {
                        let currentText = signatureText
                        Task { @MainActor in
                            // Indicate re-check in progress by clearing to not-analyzed state
                            isRetypeValid = nil
                            print("CHECKING WITH AI MODEL")
                            let isValid = await isValidRetype(phraseToBeTyped: randomSentence, phraseTyped: currentText)
                            isRetypeValid = isValid
                            print("MODEL RETURNED")
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .font(.body.weight(.semibold))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.secondary)
                            .padding(6)
                            .background(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(Color(.white))
                            )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color(.white))
                        .shadow(color: .black.opacity(0.05), radius: 6, y: 2)
                )
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.9), value: isRetypeValid)
    }
}

#Preview {
    ContractView(isRetypeValid: .constant(nil))
        .padding()
        .background(Color.gray.opacity(0.1))
    
}

