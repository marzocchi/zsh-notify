on run ttyName
    set ttyName to first item of ttyName

    tell application id "com.apple.terminal"
        if frontmost is not true then return false

        tell first item of (first tab of windows whose tty is "/dev/ttys008")
            return selected
        end tell

    end tell
end run

