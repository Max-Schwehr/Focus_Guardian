import SwiftUI
import SwiftData

#if os(macOS)
import AppKit
#endif

#if os(macOS)
struct FloatingWindowView: View {
    @State private var macOSWindowSize: CGSize = CGSize(width: 100, height: 40)
    @State private var timerSize: CGSize = CGSize(width: 100, height: 40)
    @State private var showingMenu = false
    @State private var isHoveringFloatingClock = false
    @State private var isHoveringFloatingMenu = false
    @Query var sessions: [FocusSession]
    @Environment(\.modelContext) var modelContext
    @State private var activeSession : FocusSession? = nil

    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Rectangle()
                .frame(width: macOSWindowSize.width, height: macOSWindowSize.height)
                .foregroundStyle(Color.clear)
                .onChange(of: isHoveringFloatingClock) { oldValue, newValue in closeOpenMenu() }
                .onChange(of: isHoveringFloatingMenu) { oldValue, newValue in closeOpenMenu() }
                .onChange(of: sessions) { refreshActiveSession() }
                .onAppear { refreshActiveSession() }
            
            VStack(alignment: .trailing) {
                FloatingWindowClockView(timeText: "mins \(activeSession?.targetLength ?? 0)", size: timerSize)
                    .onContinuousHover { phase in
                        switch phase {
                        case .active(_):
                            isHoveringFloatingClock = true
                            print("isHoveringFloatingClock: \(isHoveringFloatingClock)")
                        case .ended:
                            isHoveringFloatingClock = false
                            print("isHoveringFloatingClock: \(isHoveringFloatingClock)")
                        }
                    }
                
                Spacer()
            }
            VStack {
                if showingMenu {
                    FloatingWindowMenuView(size: CGSize(width: 250, height: 120))
                        .onContinuousHover { phase in
                            switch phase {
                            case .active(_):
                                isHoveringFloatingMenu = true
                                print("isHoveringFloatingMenu: \(isHoveringFloatingMenu)")

                            case .ended:
                                isHoveringFloatingMenu = false
                                print("isHoveringFloatingMenu: \(isHoveringFloatingMenu)")

                            }
                        }
                }
            }
            .animation(.spring(), value: showingMenu)
        }
        
    }

   
    private func offsetCGSize(input: CGSize, xOffset: CGFloat, yOffset: CGFloat) -> CGSize {
        return CGSize(width: input.width + xOffset, height: input.height + yOffset)
    }
    
    private func resizeWindow(newSize: CGSize) {
        print("macOSWindowSize.height: \(macOSWindowSize.height)")
        print("newSize.height: \(newSize.height)")
        
        // We resize the MacOS Window with some padding, that way when the liquid glass preforms a spring animation, it does not clip the macOS Window
        let newSizeWithPadding = offsetCGSize(input: newSize, xOffset: 0, yOffset: 0)
        
        // Move the window position to keep the liquid glass part at the same position
        FloatingWindowManager.shared.moveWindow(xOffset: macOSWindowSize.width - newSizeWithPadding.width, yOffset: 0)
        
        // Resize the MacOS window
        macOSWindowSize = newSizeWithPadding
    }

    private func closeOpenMenu() {
        if isHoveringFloatingClock || isHoveringFloatingMenu {
            resizeWindow(newSize: CGSize(width: 275 + 10, height: 120 + 40 + 10))
            showingMenu = true
        } else {
            print("SHOULD CLOSE")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showingMenu = false
                if (!isHoveringFloatingMenu && !isHoveringFloatingClock) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        resizeWindow(newSize: CGSize(width: 100, height: 40))
                    }
                }
            }
        }

    }
    
    private func refreshActiveSession() {
        do {
            activeSession = try getMostRecentFocusSession(list: sessions)
            print("Refreshed most recent focus session: Date = \(String(describing: activeSession?.date)) Length = \(String(describing: activeSession?.targetLength))")
        } catch {
            print("No active session available or error: \(error)")
        }
    }
}

#Preview("TimerOverlayView") {
    FloatingWindowView()
        .padding()
}
#endif

