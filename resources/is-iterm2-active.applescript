on run ttyName
    set ttyName to first item of ttyName

    tell application "System Events"
        tell item 1 of (application processes whose bundle identifier is "com.googlecode.iterm2")
            if frontmost is not true then return false
        end tell
    end tell

    tell application id "com.googlecode.iterm2"
        return tty of (current session of current tab of current window) is equal to ttyName
    end tell

end run
