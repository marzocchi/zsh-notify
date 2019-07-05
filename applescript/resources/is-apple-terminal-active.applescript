#!/usr/bin/osascript -ss

on run ttyName
	try
		set ttyName to first item of ttyName
	on error
		set ttyName to ""
	end try
	
	if ttyName is equal to "" then error "Usage: is-apple-terminal-active.applescript TTY"
	
	tell application id "com.apple.terminal"
		if frontmost is not true then error "Apple Terminal is not the frontmost application"
	
		-- fun stuff, with 2 tabs in one window AS reports 2 windows with one
		-- tab each, and all the tabs are frontmost!
		repeat with t in tabs of (windows whose frontmost is true)
			if t's tty is equal to ttyName then return
		end repeat
		
		error "Cannot find an active tab for '" & ttyName & "'"
		
	end tell
end run
