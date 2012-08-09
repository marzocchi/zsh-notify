zsh-notify
=======

A plugin for the Z shell (and OS X) that posts desktop notifications
when any command fails or when a long-running command finish without
errors, if the terminal application is in the background.

Requirements
---

- [terminal-notifier.app][terminal-notifier] is required for posting to
  Mountain Lion's Notification Center

- [growlnotify][growlnotify] is required for posting to Growl in older
  versions of Mac OS X.

- Either Terminal.app or [iTerm2][iterm2].

Usage: 
---

Just source it.

Configuration:
---

By default, a notification about a "long-running", successful, command is
posted only if it took at least 30 seconds to complete. To change this
timeout, set the `NOTIFY_COMMAND_COMPLETE_TIMEOUT` environment variable
to a value (in seconds).

Also, the plugin assumes that `terminal-notifier.app` is installed in
`/Applications` and that `growlnotify` lives in `/usr/local/bin`. You can
change these defaults by setting the `$SYS_NOTIFIER` and `$GROWL_NOTIFIER`
environment variables.

[growlnotify]: http://growl.info/extras.php/#growlnotify
[terminal-notifier]: https://github.com/alloy/terminal-notifier 
[iterm2]: http://www.iterm2.com/

