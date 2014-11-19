on run ttyName
    set ttyName to first item of ttyName

    tell application id "com.googlecode.iterm2"
        return frontmost and (tty of (current session of current terminal) is equal to ttyName
    end tell

end run
