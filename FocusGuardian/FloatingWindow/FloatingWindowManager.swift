import SwiftUI
#if os(macOS)
import AppKit
import SwiftData

/// A small always-on-top floating window that hosts a SwiftUI timer view with Liquid Glass.
@MainActor
final class FloatingWindowManager: NSObject {
    static let shared = FloatingWindowManager()

    private var panel: NSPanel?
    private var injectedContainer: ModelContainer?
    
    /// Margin from screen edges when positioning in the top-right corner.
    private let screenMargin: CGFloat = 7

    private override init() { super.init() }

    func show(using container: ModelContainer) {
        if panel == nil {
            createPanel(using: container)
        }
        guard let panel else { return }
        positionPanelTopRight(panel)
        panel.level = .statusBar
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        panel.orderFrontRegardless()
        NSApp.activate(ignoringOtherApps: false)
    }

    /// Hide (but keep) the floating panel.
    func hide() {
        panel?.orderOut(nil)
    }

    /// Destroy the panel completely.
    func close() {
        panel?.close()
        panel = nil
    }
    
    func moveWindow(xOffset: CGFloat, yOffset: CGFloat) {
        guard let panel else { return }
        // Current frame and screen
        let currentFrame = panel.frame

        // Compute unclamped new origin (AppKit origin is bottom-left)
        let newOrigin = NSPoint(x: currentFrame.origin.x + xOffset,
                                y: currentFrame.origin.y + yOffset)

        panel.setFrameOrigin(newOrigin)
    }

    private func createPanel(using container: ModelContainer) {
        let panel = NSPanel(
            contentRect: NSRect(origin: .zero, size: CGSize(width: 0, height: 0)),
            styleMask: [.nonactivatingPanel, .borderless],
            backing: .buffered,
            defer: false
        )
        panel.isOpaque = false
        panel.backgroundColor = .clear
        panel.hidesOnDeactivate = false
        panel.hasShadow = true
        panel.level = .statusBar // above normal windows
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        panel.ignoresMouseEvents = false
        panel.isMovableByWindowBackground = true
        panel.titleVisibility = .hidden
        panel.titlebarAppearsTransparent = true
        panel.animationBehavior = .utilityWindow

        // Host SwiftUI view with the injected SwiftData model container so @Query works
        let hosting = NSHostingView(rootView: FloatingWindowView().modelContainer(container))
        hosting.frame = NSRect(origin: .zero, size: CGSize(width: 0, height: 0))
        hosting.autoresizingMask = [.width, .height]
        panel.contentView = hosting

        self.panel = panel
        self.injectedContainer = container
    }

    private func positionPanelTopRight(_ panel: NSPanel) {
        guard let screen = NSScreen.main ?? NSScreen.screens.first else { return }
        let full = screen.frame
        let x = full.maxX - 100 - screenMargin
        let y = full.maxY - 40 - screenMargin
        panel.setFrameOrigin(NSPoint(x: x, y: y))
    }
}
#endif

