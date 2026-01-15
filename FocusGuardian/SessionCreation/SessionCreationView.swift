import SwiftUI
import SwiftData

enum SessionStep: Int, CaseIterable {
    case timeInput
    case livesInput
    case contentBlockingInput
    case contractInput
}

struct SessionCreationView: View {
    // MARK: - State previously in SessionOnboardingView
    @State var step: SessionStep = .timeInput
    @State private var isAdvancing: Bool = true
    @State private var isContractValid: Bool? = nil
    @State private var lives : Int? = 0
    @State private var sections : [FocusSection] = []

    @Query var sessions: [FocusSession]
    @Environment(\.modelContext) var modelContext
    private var modelContainer: ModelContainer { modelContext.container }

    #if os(macOS)
    @State private var didShowFloatingTimer = false
    #endif

    var body: some View {
        VStack(spacing: 16) {
            // Main step content
            ZStack {
                switch step {
                case .timeInput:
                    TimeInputView(lives: $lives, sections: $sections)
                        .transition(transitionForCurrentDirection())
                case .contentBlockingInput:
                    ContentBlockingView()
                        .transition(transitionForCurrentDirection())
                case .livesInput:
                    LivesInputView(lives: $lives)
                        .transition(transitionForCurrentDirection())
                case .contractInput:
                    ContractView(isRetypeValid: $isContractValid)
                        .transition(transitionForCurrentDirection())
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            .animation(.spring(response: 0.45, dampingFraction: 0.9), value: step)
            .animation(.spring(response: 0.45, dampingFraction: 0.9), value: isAdvancing)
            .onChange(of: sessions) { oldValue, newValue in
                // Persist before showing floating window
                do {
                    try modelContext.save()
                } catch {
                    print("Failed to save context before showing floating window: \(error)")
                }
                #if os(macOS)
                if !didShowFloatingTimer { // Normally also check contract validity
                    didShowFloatingTimer = true
                    FloatingMacOSWindowManager.shared.show(using: modelContainer)
                    // Optionally close the onboarding window
                    NSApp.keyWindow?.close()
                }
                #endif
            }

            // Navigation buttons
            VStack {
                HStack(alignment: .bottom, spacing: 12) {
                    // MARK: - Back Button
                    VStack {
                        // Text showing the keyboard shortcut to trigger the button
                        if previousStep(from: step) != nil {
                            HStack (spacing: 0) {
                                Image(systemName: "chevron.left.square.fill")
                                Text(" + ")
                                Image(systemName: "command")
                            }
                            .font(.caption2)
                            .opacity(0.3)
                        }
                        
                        // Back Button
                        Button(action: goBack) {
                            Label("Back", systemImage: "chevron.up")
                                .labelStyle(.titleAndIcon)
                                .font(.headline)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .contentShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }
                        .buttonStyle(.plain)
                        .glassEffect()
                        .shadow(color: .black.opacity(0.15), radius: 12, y: 4)
                        .disabled(previousStep(from: step) == nil)
                        .keyboardShortcut(.leftArrow, modifiers: [.command])

                    }
                    Spacer()
                    
                    // MARK: - Next / Complete Button
                    VStack {
                        // Text showing the keyboard shortcut to trigger the button
                        HStack(spacing: 0) {
                            Image(systemName: "command")
                            Text(" + ")
                            Image(systemName: "chevron.right.square.fill")
                        }
                        .font(.caption2)
                        .opacity(0.3)
                        
                        // Next Button
                        Button(action: {
                            goNext()
                            do { try modelContext.save() } catch { print("Failed to save after insert: \(error)") }
                        }) {
                            Label(step == .contractInput ? "Start Focus Timer" : "Next", systemImage: step == .livesInput ? "checkmark" : "chevron.down")
                                .labelStyle(.titleAndIcon)
                                .font(.headline)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .contentShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }
                        .buttonStyle(.plain)
                        .foregroundStyle(.white)
                        .glassEffect(.regular.tint(.blue))
                        .shadow(color: .black.opacity(0.15), radius: 12, y: 4)
                        .keyboardShortcut(.rightArrow, modifiers: [.command])
                        .disabled(step == .contractInput && isContractValid != true)
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(.ultraThinMaterial)
        .ignoresSafeArea()
        .navigationTitle("")
        .scrollContentBackground(.hidden)
        .background(.clear)
    }

    // MARK: - Actions
    private func goNext() {
        if step == .contractInput {
            // Finalize and create a session based on inputs
            
            // MARK: This code is the real app code that has been commented out of testing
            let session = FocusSession(completedLength: 0, date: Date(), totalHeartsCount: lives ?? 0, problemOccurred: false, sections: sections)
                        modelContext.insert(session)

            // MARK: Testing code
//            let session = FocusSession(completedLength: 0, date: Date(), totalHeartsCount: 3, problemOccurred: false, sections: [
//                FocusSection(length: 1, isFocusSection: true),
//                FocusSection(length: 1, isFocusSection: true)
//            ])
//            modelContext.insert(session)
            
            do { try modelContext.save() } catch { print("Failed to save after insert: \(error)") }
        } else if let next = nextStep(from: step) {
            isAdvancing = true
            withAnimation { step = next }
        }
    }

    private func goBack() {
        guard let previous = previousStep(from: step) else { return }
        isAdvancing = false
        withAnimation { step = previous }
    }

    // MARK: - Step helpers
    private func nextStep(from step: SessionStep) -> SessionStep? {
        let all = SessionStep.allCases
        if let idx = all.firstIndex(of: step), idx + 1 < all.count {
            return all[idx + 1]
        }
        return nil
    }

    private func previousStep(from step: SessionStep) -> SessionStep? {
        let all = SessionStep.allCases
        if let idx = all.firstIndex(of: step), idx - 1 >= 0 {
            return all[idx - 1]
        }
        return nil
    }

    private func transitionForCurrentDirection() -> AnyTransition {
        if isAdvancing {
            return .asymmetric(
                insertion: .move(edge: .bottom).combined(with: .opacity),
                removal: .move(edge: .top).combined(with: .opacity)
            )
        } else {
            return .asymmetric(
                insertion: .move(edge: .top).combined(with: .opacity),
                removal: .move(edge: .bottom).combined(with: .opacity)
            )
        }
    }
}

#Preview {
    NavigationStack { SessionCreationView() }
}
