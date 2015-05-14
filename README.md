**Find a version that works with iTerm2's nightlies in the
[“next-iterm” branch →](https://github.com/marzocchi/zsh-notify/tree/next-iterm)**

zsh-notify
=======

A plugin for the Z shell (on OS X and Linux) that posts desktop notifications
when a command terminates with a non-zero exit status or when it took more than
30 seconds to complete, if the terminal application is in the background (or
the command's terminal tab is inactive).

Requirements
---

- Either Terminal.app or [iTerm2][iterm2] on OSX and any terminal emulator on
  Linux should work.

- [terminal-notifier.app][terminal-notifier] is required for posting to
  Mountain Lion's Notification Center

- [growlnotify][growlnotify] is required for posting to Growl in previous
  versions of Mac OS X.

- notify-send (libnotify-bin) and xdotool are required for Linux systems.
  Wmctrl is optional and provides support for focusing the terminal in
  addition to a notification.


Usage
---

Just source notify.plugin.zsh.

Configuration:
---

While notifications about failed commands are always posted, notifications
for successful commands are posted only if they took at least 30 seconds to
complete. To change the timeout set the NOTIFY_COMMAND_COMPLETE_TIMEOUT
environment variable to a different value in seconds.

Also, the plugin assumes that both `terminal-notifier` and `growlnotify` are
installed in `/usr/local/bin`. You can change these defaults by setting the
`$SYS_NOTIFIER` or `$GROWL_NOTIFIER` environment variables.

On Linux if you have wmctrl installed, then you can set the $ZSH_NOTIFY_FOCUS_TERMINAL
enviroment variable to "true" to change focus to the terminal emulator window when a notification
is posted. By default the terminal window will just demand attention.


[growlnotify]: http://growl.info/extras.php/#growlnotify
[terminal-notifier]: https://github.com/alloy/terminal-notifier 
[iterm2]: http://www.iterm2.com/

