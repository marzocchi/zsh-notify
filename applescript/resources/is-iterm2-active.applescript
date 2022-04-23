#!/usr/bin/osascript

on run ttyName
    try 
        set ttyName to first item of ttyName
    on error
        set ttyName to ""
    end

    if ttyName is equal to "" then error "Usage: is-iterm2-active.applescript TTY"

    tell application id "com.googlecode.iterm2"
        tell current window
            set isHotkeyWindow to is hotkey window
            if isHotkeyWindow and visible is not true then error "iTerm is not the frontmost application"
        end tell
    end tell

    if isHotkeyWindow is not true then
        tell application "System Events"
            tell item 1 of (application processes whose bundle identifier is "com.googlecode.iterm2")
                if frontmost is not true then error "iTerm is not the frontmost application"
            end tell
        end tell
    end if

    tell application id "com.googlecode.iterm2"
        set currentTty to tty of (current session of current tab of current window) as text
        if currentTty is not equal to ttyName then error "Current tab TTY '" & currentTty & "' does not match expected '" & ttyName & "'" 
    end tell

end run
