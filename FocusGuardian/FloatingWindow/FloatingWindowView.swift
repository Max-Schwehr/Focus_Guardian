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
    @State private var timerSize: CGSize = CGSize(width: 100, height: 40)
    @State private var menuSize: CGSize = CGSize(width: 0, height: 0)
    @State private var livesSize: CGSize = CGSize(width: 0, height: 0)
    
    @State private var requestedLivesSize: CGSize = CGSize(width: 0, height: 0) // Remember, all variables above must use the requestSizeChange function in-order to maintain proper order, relation, and animations within this file. Thus, child views can adjust this variable, and when this changes we run the function.
    
    @State private var floatingClockViewContentOption : FloatingClockViewContentOptions = .Clock
    
    let padding : CGFloat = 10
    let expandedMenuSize = CGSize(width: 260, height: 120)
    let outsidePadding : CGFloat = 10
    let debugMode = false
    
    // Size of the timer liquid glass
    @State private var showingMenu = false // isShowing Detail Menu
    @State private var isHoveringFloatingClock = false // If the user is hovering on the clock
    @State private var isHoveringFloatingMenu = false // If the user is hovering on the detail menu
    
    // Lives information
    @State private var livesLost = 0
    
    // MARK: Swift Data & Major Data Management
    @Query var sessions: [FocusSession]
    @Environment(\.modelContext) var modelContext
    @State private var activeSession : FocusSession? = nil
    
    // MARK: Camera Logic
    @StateObject private var headTracker = CameraManager()
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // MARK: - MacOS window's rectangle, dictating the MacOS window's size
            Rectangle()
                .frame(width: macOSWindowSize.width, height: macOSWindowSize.height)
                .foregroundStyle(Color.clear)
                .onChange(of: sessions) { refreshActiveSession() }
                .onAppear {
                    refreshActiveSession() // Retrieve the active session from Swift Data
                    headTracker.requestAccessAndConfigure() // Start up camera
                }
                .task { // Reduces seconds remaining by 1 every second
                    while secondsRemaining > 0 {
                        try? await Task.sleep(for: .seconds(1))
                        secondsRemaining -= 800
                        if secondsRemaining <= 0 {
                            floatingClockViewContentOption = .TimerCompletedView
                            RequestSizeChange(itemToChange: .Timer, newSize: CGSize(width: 300, height: 250))
                        }
                    }
                }
                .onChange(of: requestedLivesSize, { oldValue, newValue in
                    print("Requested Size Change Height: \(newValue.height)")
                    RequestSizeChange(itemToChange: .Lives, newSize: newValue)
                })
                .border(debugMode ? .black : .clear)
            
            VStack(alignment: .trailing) {
                // MARK: - Floating Liquid Glass Timer
                FloatingClockView(size: $timerSize, secondsRemaining: $secondsRemaining, livesLost: $livesLost, requestedLivesSize: $requestedLivesSize, viewContentOptions: $floatingClockViewContentOption)
                    .onContinuousHover { phase in // SHOULD OPEN CLOSE MENU
                        switch phase {
                        case .active(_):
                            RequestSizeChange(itemToChange: .Menu, newSize: expandedMenuSize)
                        case .ended:
                            RequestSizeChange(itemToChange: .Menu, newSize: CGSize(width: 0, height: 0))
                        }
                    }
                    .onChange(of: headTracker.hasFace) { _, hasFace in // SHOULD SHOW "NOT SHOWING FACE" SIGN
                        print("Camera has face: \(hasFace)")
                        if hasFace {
                            floatingClockViewContentOption = .Clock
                            RequestSizeChange(itemToChange: .Timer, newSize: CGSize(width: 100, height: 40))
                        } else {
                            floatingClockViewContentOption = .FaceNotVisible
                            RequestSizeChange(itemToChange: .Timer, newSize: CGSize(width: 200, height: 80))
                        }
                    }                        .border(debugMode ? Color.red : Color.clear)
                
                ZStack(alignment: .topTrailing) {
                    if livesSize.width + livesSize.height > 0 {
                        FloatingLivesView(totalHearts: activeSession?.totalHeartsCount ?? 0, size: $livesSize, livesLost: $livesLost)
                                          .border(debugMode ? Color.red : Color.clear)

                    }
//                    Spacer()
                }
                .animation(.spring(), value: livesSize.width + livesSize.height > 0)

                ZStack(alignment: .topTrailing) {
                    if menuSize.width + menuSize.height > 0 {
                        // MARK: - Floating Detail Menu
                        FloatingMenuView(size: menuSize, secondsRemaining: $secondsRemaining, activeSession: $activeSession)
                            .onContinuousHover { phase in // SHOULD OPEN CLOSE MENU
                                switch phase {
                                case .active(_):
                                    RequestSizeChange(itemToChange: .Menu, newSize: expandedMenuSize)
                                case .ended:
                                    RequestSizeChange(itemToChange: .Menu, newSize: CGSize(width: 0, height: 0))
                                }
                            }
                            .border(debugMode ? Color.red : Color.clear)
                    }
                }
                    .animation(.spring(), value: menuSize.width + menuSize.height > 0)
                Spacer()
            }
            
        }
        
    }
    
    // MARK: Request to Change Size Function
    /// This function allows the input of what is changing, and what its new CGSize for that component should be.
    enum ItemOnScreen {
        case Timer
        case Menu
        case Lives
    }
    private func RequestSizeChange(itemToChange: ItemOnScreen, newSize: CGSize) {
        // Get old size
        var oldSize = CGSize()
        switch itemToChange {
        case .Menu:
            oldSize = menuSize
        case .Timer:
            oldSize = timerSize
        case .Lives:
            oldSize = livesSize
        }
        
        // Increase element size
            switch itemToChange {
            case .Menu:
                menuSize = newSize
            case .Timer:
                timerSize = newSize
            case .Lives:
                livesSize = newSize
            }
        
        if (newSize.width < oldSize.width || newSize.height < oldSize.height) { // If the object is decreasing its size, we need to wait till the item's animation play's before resizing the MacOS Window
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                ComputeNewMacOSWindowSize()
            }
        } else {
            ComputeNewMacOSWindowSize()
        }
        
        func ComputeNewMacOSWindowSize () {
            // Compute new MacOS window Size
            var totalSize : CGSize = CGSize(width: 0, height: 0)
            totalSize.width = max(timerSize.width, menuSize.width, livesSize.width) + padding + outsidePadding*2
            totalSize.height = timerSize.height + menuSize.height + livesSize.height + padding + outsidePadding*2
            resizeMacOSWindow(newSize: totalSize)
        }
    }
    
    // MARK: - Floating Window Functions
    private func offsetCGSize(input: CGSize, xOffset: CGFloat, yOffset: CGFloat) -> CGSize {
        return CGSize(width: input.width + xOffset, height: input.height + yOffset)
    }
    
    private func resizeMacOSWindow(newSize: CGSize) {
        print("macOSWindowSize.height: \(macOSWindowSize.height)")
        print("newSize.height: \(newSize.height)")
        
        // Move the window position to keep the liquid glass part at the same position
        FloatingWindowManager.shared.moveWindow(xOffset: macOSWindowSize.width - newSize.width, yOffset: 0)
        
        // Resize the MacOS window
        macOSWindowSize = newSize
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

