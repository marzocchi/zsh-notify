**Find a version that works with iTerm2's nightlies in the
[“next-iterm” branch →](https://github.com/marzocchi/zsh-notify/tree/next-iterm)**

zsh-notify
=======

A plugin for the Z shell (on OS X) that posts desktop notifications when a
command terminates with a non-zero exit status or when it took more than 30
seconds to complete, if the terminal application is in the background (or the
command's terminal tab is inactive).

Requirements
---

- Either Terminal.app or [iTerm2][iterm2].

- [terminal-notifier.app][terminal-notifier] is required for posting to
  Mountain Lion's Notification Center

- [growlnotify][growlnotify] is required for posting to Growl in previous
  versions of Mac OS X.

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


[growlnotify]: http://growl.info/extras.php/#growlnotify
[terminal-notifier]: https://github.com/alloy/terminal-notifier 
[iterm2]: http://www.iterm2.com/

