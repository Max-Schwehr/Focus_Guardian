//
//  SafariAppleScript.swift
//  FocusGuardian
//
//  Created by Maximiliaen Schwehr on 12/28/25.
//

import Foundation

extension WebsiteBlockerSession {
    func blockWebsitesOnSafari() {
        let script = """
        set input to {\(blockedWebsitesAsAppleScript())}
        
        if application "Safari" is not running then return
        
        tell application "Safari"
            if (count of windows) = 0 then return
        
            set currentDocument to front document
            set currentURL to URL of currentDocument
        
            repeat with blockedSite in input
                if currentURL contains (blockedSite as text) then
                    set URL of currentDocument to "https://many-slide-999700.framer.app/"
                    exit repeat
                end if
            end repeat
        end tell
        """
        runAppleScript(script)
    }
    
    
    func blockedWebsitesAsAppleScript() -> String {
        return blockedWebsites .map { "\"\($0)\"" } .joined(separator: ", ")
    }
    
    func blockWebsitesOnGoogleChrome() {
        let script = """
        set input to {\(blockedWebsitesAsAppleScript())}
        
        if application "Google Chrome" is not running then return
        
        tell application "Google Chrome"
            if (count of windows) = 0 then return
        
            set currentTab to active tab of front window
            set currentURL to URL of currentTab
        
            repeat with blockedSite in input
                if currentURL contains (blockedSite as text) then
                    set URL of currentTab to "https://many-slide-999700.framer.app/"
                    exit repeat
                end if
            end repeat
        end tell
        """
        runAppleScript(script)
    }
    
}
