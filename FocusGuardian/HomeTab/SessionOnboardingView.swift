import SwiftUI
import SwiftData

#if os(macOS)
import AppKit
#endif

private enum SessionStep: Int, CaseIterable {
    case timeInput
    case livesInput
    case contractInput
}

struct SessionOnboardingView: View {
    @State private var step: SessionStep = .timeInput
    @State private var isAdvancing: Bool = true
    @State private var isContractValid: Bool? = nil
    @State private var hours : Int = 0
    @State private var minutes : Int = 0
    @State private var lives : Int = 0
    
    @Query var sessions: [FocusSession]
    @Environment(\.modelContext) var modelContext
    private var modelContainer: ModelContainer { modelContext.container }
    
#if os(macOS)
    @State private var didShowFloatingTimer = false
#endif
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                switch step {
                case .timeInput:
                    TimeInputView(hours: $hours, minutes: $minutes, lives: $lives)
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
                // Open the floating timer view
                do {
                    try modelContext.save()
                } catch {
                    print("Failed to save context before showing floating window: \(error)")
                }
                #if os(macOS)
                if !didShowFloatingTimer{ // Normally and & is contract valid
                    didShowFloatingTimer = true
                    FloatingWindowManager.shared.show(using: modelContainer)
                    // Optionally close the onboarding window
                    NSApp.keyWindow?.close()
                }
                #endif
            }
            
            HStack(spacing: 12) {
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
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(.white.opacity(0.15))
                )
                .shadow(color: .black.opacity(0.15), radius: 12, y: 4)
                .disabled(previousStep(from: step) == nil)
                
                Spacer()
                
                Button(action: {
                    
                    let session = FocusSession(targetLength: 120, completed: false, date: Date(), totalLivesCount: 5)
                    modelContext.insert(session)
                    do { try modelContext.save() } catch { print("Failed to save after insert: \(error)") }
                    //normally next step
                    
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
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(.white.opacity(0.15))
                )
                .shadow(color: .black.opacity(0.15), radius: 12, y: 4)
                .keyboardShortcut(.defaultAction)
                .disabled(step == .contractInput && isContractValid != true)
#if os(macOS)
                .task {
                    
                }
#endif
            }
        }
    }
    
    // MARK: - Actions
    private func goNext() {
        if step == .contractInput {
            // Handle completion if needed
            print("Pre Insert Session Length: \(sessions.count)")
            let session = FocusSession(targetLength: hours * 60 + minutes, completed: false, date: Date(), totalLivesCount: lives)
            modelContext.insert(session)
            do { try modelContext.save() } catch { print("Failed to save after insert: \(error)") }
            print("INSERTED!!!")
            print("post Insert Session Length: \(sessions.count)")

        } else if let next = nextStep(from: step) {
            isAdvancing = true
            
            withAnimation {
                step = next
            }
        }
    }
    
    private func goBack() {
        guard let previous = previousStep(from: step) else { return }
        isAdvancing = false
        withAnimation {
            step = previous
        }
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
    NavigationStack { SessionOnboardingView() }
}
