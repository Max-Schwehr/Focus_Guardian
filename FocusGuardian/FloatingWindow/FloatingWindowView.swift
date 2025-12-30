import SwiftUI
import SwiftData

#if os(macOS)
import AppKit
#endif

#if os(macOS)

var standardAnimation : Animation = .spring(duration: 0.5, bounce: 0.3)

// This view is what host all the "floating" elements of the app, like the floating timer, and other floating menus
struct FloatingWindowView: View {
    // Describes how many minutes the timer has left, initially set to the `activeSession`'s value for targetMinutes by the `refreshActiveSession` function
    @State var secondsRemaining = 0
    @State var isCountingDown = true // Is counting Up or Down?
    @State var showStopButton = false
    
    // Behind each floating element, is a clear MacOS window, the quickly expands or retracts to be able to fit any animations, or content that appears floating to the user.
    @State var macOSWindowSize: CGSize = CGSize(width: 100, height: 40)
    @State var timerSize: CGSize = CGSize(width: 100, height: 40)
    @State var menuSize: CGSize = CGSize(width: 0, height: 0)
    @State var livesSize: CGSize = CGSize(width: 0, height: 0)
    
    @State var requestedLivesSize: CGSize = CGSize(width: 0, height: 0) // Remember, all variables above must use the requestSizeChange function in-order to maintain proper order, relation, and animations within this file. Thus, child views can adjust this variable, and when this changes we run the function.
    
    @State var floatingClockViewContentOption : FloatingClockViewContentOptions = .Clock
    
    let padding : CGFloat = 10
    let expandedMenuSize = CGSize(width: 260, height: 120)
    let outsidePadding : CGFloat = 10
    let debugMode = false
    
    // Size of the timer liquid glass
    
    // Lives information
    @State private var livesLost = 0
    
    // MARK: Swift Data & Major Data Management
    @Query var sessions: [FocusSession]
    @Environment(\.modelContext) var modelContext
    @State var activeSession : FocusSession? = nil
    
    // MARK: Camera Logic
    @StateObject var headTracker = CameraManager()
    
    @StateObject private var blocker = WebsiteBlockerSession()

    
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
                    blocker.start() // Start the website blocker, if there are any websites to block
                }
                .task { await runCountdownTimer() }
                .onChange(of: requestedLivesSize, { oldValue, newValue in requestSizeChange(itemToChange: .lives, newSize: newValue) })
                .onChange(of: isCountingDown, { _, isCountingDown in
                    if !isCountingDown {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
                            print("REQUESTED STOP BUTTON")
                            withAnimation {
                                showStopButton = true
                            }
                            requestSizeChange(itemToChange: .stopButton, newSize: CGSize(width: 40, height: 40)) // Note, this must only be greater then zero for the function to add width, .stopButton has a special implementation within the function
                        }
                    }
                })
                .onChange(of: headTracker.hasFace) { _, hasFace in handleFaceDetectionChange(hasFace) }
                .border(debugMode ? .black : .clear)
//                .glassEffect(.regular.tint(.blue))
            
            VStack(alignment: .trailing, spacing: padding) {
                // MARK: - Floating Liquid Glass Timer
                GlassEffectContainer(spacing: 10.0) {
                    HStack(spacing: 10.0) {
                        if showStopButton {
                            Button(action: {
                                FloatingMacOSWindowManager.shared.close()
                            }) {
                                Image(systemName: "stop.circle")
                                    .frame(width: 40, height: 40)
                                    .glassEffect()
                            }
                            .buttonStyle(.plain)
                        }
                        
                        FloatingClockView(size: $timerSize, secondsRemaining: $secondsRemaining, livesLost: $livesLost, requestedLivesSize: $requestedLivesSize, viewContentOptions: $floatingClockViewContentOption, isCountingDown: $isCountingDown, onAddTime: {
                            isCountingDown = false
                            Task { await runCountdownTimer()}
                            floatingClockViewContentOption = .Clock
                            requestSizeChange(itemToChange: .timer, newSize: CGSize(width: 100, height: 40)) }, onEndSession: {
                                FloatingMacOSWindowManager.shared.close()
                                blocker.stop()
                            })
                        .border(debugMode ? Color.red : Color.clear)
                        .onContinuousHover { phase in // SHOULD OPEN CLOSE MENU
                            hideShowMenu(phase: phase)
                        } .animation(standardAnimation, value: timerSize)
                            .onTapGesture {
                                secondsRemaining = 5
                            }
                    }
                }
                .frame(width: showStopButton ? timerSize.width + 50 : timerSize.width) // Add width for the stop button if it is there
                // MARK: - Floating Lives View
                ZStack(alignment: .topTrailing) {
                    if livesSize.width + livesSize.height > 0 {
                        FloatingLivesView(totalHearts: activeSession?.totalHeartsCount ?? 0, size: $livesSize, livesLost: $livesLost)
                                         
                    }
                } .animation(standardAnimation, value: livesSize) .border(debugMode ? Color.red : Color.clear)
                

                // MARK: - Floating Detail Menu
                ZStack(alignment: .topTrailing) {
                    if menuSize.width + menuSize.height > 0 {
                        FloatingMenuView(size: menuSize, secondsRemaining: $secondsRemaining, activeSession: $activeSession)
                            .onContinuousHover { phase in // SHOULD OPEN CLOSE MENU
                                hideShowMenu(phase: phase)
                            }
                    }
                } .animation(standardAnimation, value: menuSize)
                    .border(debugMode ? Color.red : Color.clear)

                
                Spacer()

            }                    .border(debugMode ? Color.green : Color.clear).frame(height: macOSWindowSize.height)

            
        }        
    }
}

#Preview("TimerOverlayView") {
    FloatingWindowView()
        .padding()
}
#endif


