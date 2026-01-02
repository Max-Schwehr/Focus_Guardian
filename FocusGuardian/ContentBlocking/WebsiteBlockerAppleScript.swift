//
//  SafariAppleScript.swift
//  FocusGuardian
//
//  Created by Maximiliaen Schwehr on 12/28/25.
//

import Foundation

private let cleanUpURLScript = """
    on domainFromURL(theURL)
        set cleanURL to theURL as text
        
        -- Remove protocol
        if cleanURL starts with "http://" then
            set cleanURL to text 8 thru -1 of cleanURL
        else if cleanURL starts with "https://" then
            set cleanURL to text 9 thru -1 of cleanURL
        end if
        
        -- Remove path (anything after first "/")
        if cleanURL contains "/" then
            set cleanURL to text 1 thru ((offset of "/" in cleanURL) - 1) of cleanURL
        end if
        
        -- Remove "www."
        if cleanURL starts with "www." then
            set cleanURL to text 5 thru -1 of cleanURL
        end if
        
        return cleanURL
    end domainFromURL
    """

extension BlockerSession {

    func blockWebsitesOnSafari() {
        let script = """
        set input to {\(blockedWebsitesAsAppleScript())}
        
        \(cleanUpURLScript)
        -- Define the function to clean up URLs in this script
        
        if application "Safari" is not running then return


        tell application "Safari"
            if (count of windows) = 0 then return
            
            set currentDocument to front document
            set currentURL to URL of currentDocument
            
            repeat with blockedSite in input
                if currentURL contains (blockedSite as text) and not (currentURL contains "framer.app") then
                    set formattedURL to my domainFromURL(currentURL)
                    set URL of currentDocument to "https://many-slide-999700.framer.app/?msg=" & formattedURL
                    exit repeat
                end if
            end repeat
        end tell
        """
        
        print("FULL APPLE SCRIPT!!!!!")
        print(script)
        print("END FULL APPLE SCRIPT!!")
        
        runAppleScript(script)
    }
    
    func blockWebsitesOnArc() {
        let script = """
        set input to {\(blockedWebsitesAsAppleScript())}

        if application "Arc" is not running then return
        
        \(cleanUpURLScript)
        -- Define the function to clean up URLs in this script

        tell application "Arc"
            if (count of windows) = 0 then return
        
            set currentURL to URL of active tab of front window
        
            repeat with blockedSite in input
                if currentURL contains (blockedSite as text) and not (currentURL contains "framer.app") then
                    set formattedURL to my domainFromURL(currentURL)
                    set URL of active tab of front window to "https://many-slide-999700.framer.app/?msg=" & formattedURL
                end if
            end repeat
        end tell
        """
        runAppleScript(script)
    }
    
    
    func blockWebsitesOnGoogleChrome() {
        let script = """
        set input to {\(blockedWebsitesAsAppleScript())}
        
        \(cleanUpURLScript)
        -- Define the function to clean up URLs in this script
        
        if application "Google Chrome" is not running then return
        
        tell application "Google Chrome"
            if (count of windows) = 0 then return
        
            set currentTab to active tab of front window
            set currentURL to URL of currentTab
        
            repeat with blockedSite in input
                if currentURL contains (blockedSite as text) and not (currentURL contains "framer.app") then
                    set formattedURL to my domainFromURL(currentURL)
                    set URL of currentTab to "https://many-slide-999700.framer.app/?msg=" & formattedURL
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
}
