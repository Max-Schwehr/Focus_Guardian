import SwiftUI
import SwiftData

#if os(macOS)
import AppKit
#endif

#if os(macOS)
extension FloatingWindowView {
    enum ItemOnScreen {
        case timer
        case menu
        case lives
        case stopButton
    }
    
    /// Animates resizing an item and updates the host window size accordingly.
    func requestSizeChange(itemToChange: ItemOnScreen, newSize: CGSize) {

        // Get old size
        var oldSize = CGSize()
        switch itemToChange {
        case .menu:
            oldSize = menuSize
        case .timer:
            oldSize = timerSize
        case .lives:
            oldSize = livesSize
        case .stopButton:
            print("")
            // Do nothing
        }
        
        //        withAnimation {
        // Increase element size
        switch itemToChange {
        case .menu:
            menuSize = newSize
        case .timer:
            timerSize = newSize
        case .lives:
            livesSize = newSize
        case .stopButton:
            print("")

            // Do nothing
        }
        
        if (newSize.width < oldSize.width || newSize.height < oldSize.height) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                ComputeNewMacOSWindowSize()
            }
        } else {
            ComputeNewMacOSWindowSize()
        }
        
        func ComputeNewMacOSWindowSize () {
            // Compute new MacOS window Size
            print("Current MacOS Window Size Width: \(macOSWindowSize.width)")
            print("Show Stop Button? \(showStopButton)")
            var timerSizeWidth = timerSize.width
            if showStopButton {
                timerSizeWidth += 50 // Add room for the stop button
            }
            var totalSize : CGSize = CGSize(width: 0, height: 0)
            totalSize.width = max(timerSizeWidth, menuSize.width, livesSize.width) + outsidePadding*2
            totalSize.height = timerSize.height + menuSize.height + livesSize.height + padding*2 + outsidePadding*2
            resizeMacOSWindow(newSize: totalSize)
        }
    }
    
    /// Returns a size offset by the given x and y amounts.
    func offsetCGSize(input: CGSize, xOffset: CGFloat, yOffset: CGFloat) -> CGSize {
        return CGSize(width: input.width + xOffset, height: input.height + yOffset)
    }
    
    /// Resizes and repositions the macOS host window to fit all floating content.
    func resizeMacOSWindow(newSize: CGSize) {
        // Move the window position to keep the liquid glass part at the same position
        FloatingMacOSWindowManager.shared.moveWindow(xOffset: macOSWindowSize.width - newSize.width, yOffset: 0)
        // Resize the MacOS window
        macOSWindowSize = newSize
    }
    
    /// Loads the latest focus session and updates `activeSession` and `secondsRemaining`.
    func refreshActiveSession() {
        do {
            activeSession = try getMostRecentFocusSession(list: sessions)
//            print("Refreshed most recent focus session: Date = \(String(describing: activeSession?.date)) Length = \(String(describing: activeSession?.targetLength))")
            secondsRemaining = (activeSession?.sections[0].length ?? 0) * 60
        } catch {
            print("No active session available or error: \(error)")
        }
    }
    
    /// Shows or hides the detail menu based on hover state.
    func hideShowMenu(phase: HoverPhase) {
        if floatingClockViewContentOption == .TimerCompletedView {
            return
        }
        switch phase {
            case .active(_):
                requestSizeChange(itemToChange: .menu, newSize: expandedMenuSize)
            case .ended:
                requestSizeChange(itemToChange: .menu, newSize: CGSize(width: 0, height: 0))
        }
        
    }
    
    /// Decrements the countdown each second and updates UI when it completes.
    func runCountdownTimer() async {
        while secondsRemaining > 0 || (!isCountingDown) {
            try? await Task.sleep(for: .seconds(1))
            withAnimation {
                if isCountingDown {
                    secondsRemaining -= 1
                } else {
                    secondsRemaining += 1
                }
            }
            if secondsRemaining <= 0 {
                floatingClockViewContentOption = .TimerCompletedView
                withAnimation {
                    requestSizeChange(itemToChange: .timer, newSize: CGSize(width: 300, height: 123))
                }
//                activeSession?.sections[0]. = true
                headTracker.stop() // Turn off the users camera
            }
        }
    }
    
    /// Updates timer state and size based on whether a face is detected.
    func handleFaceDetectionChange(_ hasFace: Bool) {
        if floatingClockViewContentOption != .TimerCompletedView && isCountingDown {
            if hasFace {
                floatingClockViewContentOption = .Clock
                requestSizeChange(itemToChange: .timer, newSize: CGSize(width: 100, height: 40))
            } else {
                floatingClockViewContentOption = .FaceNotVisible
                requestSizeChange(itemToChange: .timer, newSize: CGSize(width: 200, height: 80))
            }
        }
    }
}
#endif
