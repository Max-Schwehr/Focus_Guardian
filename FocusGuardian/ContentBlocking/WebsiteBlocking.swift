//
//  SafariAppleScript.swift
//  FocusGuardian
//
//  Created by Maximiliaen Schwehr on 12/28/25.
//

import Foundation

func checkSafari() {
    let script = """
    if application "Safari" is running then
        tell application "Safari"
            if (count of windows) > 0 then
                set currentURL to URL of front document
                if currentURL contains "youtube.com" then
                    set URL of front document to "https://many-slide-999700.framer.app/"
                end if
            end if
        end tell
    end if
    """
    runAppleScript(script)
}

func checkGoogleChrome() {
    let script = """
    tell application "Google Chrome"
        if (count of windows) = 0 then return

        tell front window
            set currentTab to active tab
            set currentURL to URL of currentTab

            if currentURL contains "youtube.com" then
                set URL of currentTab to "https://example.com"
            end if
        end tell
    end tell
    """
    runAppleScript(script)
}

