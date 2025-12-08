import SwiftUI
import SwiftData

#if os(macOS)
import AppKit
#endif

#if os(macOS)
// This view is what host all the "floating" elements of the app, like the floating timer, and other floating menus
struct FloatingWindowView: View {
    // Describes how many minutes the timer has left, initially set to the `activeSession`'s value for targetMinutes by the `refreshActiveSession` function
    @State private var secondsRemaining = 0
    
    // Behind each floating element, is a clear MacOS window, the quickly expands or retracts to be able to fit any animations, or content that appears floating to the user.
    @State private var macOSWindowSize: CGSize = CGSize(width: 100, height: 40)
    // Size of the timer liquid glass
    @State private var timerSize: CGSize = CGSize(width: 100, height: 40)
    @State private var showingMenu = false // isShowing Detail Menu
    @State private var isHoveringFloatingClock = false // If the user is hovering on the clock
    @State private var isHoveringFloatingMenu = false // If the user is hovering on the detail menu
    
    // MARK: Swift Data & Major Data Management
    @Query var sessions: [FocusSession]
    @Environment(\.modelContext) var modelContext
    @State private var activeSession : FocusSession? = nil
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // MARK: - MacOS window's rectangle, dictating the MacOS window's size
            Rectangle()
                .frame(width: macOSWindowSize.width, height: macOSWindowSize.height)
                .foregroundStyle(Color.clear)
                .onChange(of: isHoveringFloatingClock) { oldValue, newValue in closeOpenMenu() }
                .onChange(of: isHoveringFloatingMenu) { oldValue, newValue in closeOpenMenu() }
                .onChange(of: sessions) { refreshActiveSession() }
                .onAppear { refreshActiveSession() }
                .task { // Reduces seconds remaining by 1 every second
                    while secondsRemaining > 0 {
                        try? await Task.sleep(for: .seconds(1))
                        secondsRemaining -= 1
                    }
                }
            
            VStack(alignment: .trailing) {
                // MARK: - Floating Liquid Glass Timer
                FloatingWindowClockView(secondsRemaining: $secondsRemaining, size: timerSize)
                    .onContinuousHover { phase in // Update Hover State
                        switch phase {
                        case .active(_): isHoveringFloatingClock = true
                        case .ended: isHoveringFloatingClock = false
                        }
                    }
                
                Spacer()
            }
            VStack {
                if showingMenu {
                    // MARK: - Floating Detail Menu
                    FloatingWindowMenuView(size: CGSize(width: 250, height: 120), secondsRemaining: $secondsRemaining, totalSeconds: activeSession?.targetLength ?? 0)
                        .onAppear {print("Active Session Target Length: \(activeSession?.targetLength)")}
                        .onContinuousHover { phase in // Update Hover State
                            switch phase {
                            case .active(_): isHoveringFloatingMenu = true
                            case .ended: isHoveringFloatingMenu = false
                            }
                        }
                }
            }
            .animation(.spring(), value: showingMenu)
        }
        
    }
    
    // MARK: - Floating Window Functions
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
            secondsRemaining = (activeSession?.targetLength ?? 0) * 60 // Retrieve the number of minutes the user set the session to be, and convert that to seconds
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

