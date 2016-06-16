zsh-notify
=======

A plugin for the Z shell that posts desktop notifications when a command terminates
with a non-zero exit status or when it took more than 30 seconds to complete,
if the terminal application is in the background (or the terminal tab is inactive).

Supported terminals and requirements
---

- On Mac OS X: Terminal.app or [iTerm2][iterm2];
- On Linux (and possibly other systems): any terminal application should be supported
  as `xdotool` and `wmctrl` are used to query and modify windows state.
  
When using the default notifier notifications are posted using
[terminal-notifier.app][terminal-notifier] on Mac OS X and `notify-send`
on other systems.

Usage
---

Just source notify.plugin.zsh.

Configuration
---

Use `zstyle` in your `~/.zshrc`.

- Replace the built-in notifier with a custom one at `~/bin/my-notifier`. The custom
  notifier will receive the notification type (`error` or `success`) as the first
  argument, and the notification text (the command) as standard input.

        zstyle ':notify:*' notifier ~/bin/my-notifier

- Set a custom title for error and success notifications, when using the
  built-in notifier.

        zstyle ':notify:*' error-title
        zstyle ':notify:*' success-title

- Change the notifications icons for failure or success (any image path or URL should work):
        
        zstyle ':notify:*' error-icon "/path/to/error-icon.png"
        zstyle ':notify:*' success-icon "/path/to/success-icon.png"
    
    [Try this][dogefy.sh]. Wow.

- Have the terminal come back to front when the notification is posted.

        zstyle ':notify:*' activate-terminal yes

- Set a different timeout for notifications for successful commands
  (notifications for failed commands are posted without accounting for
  the time it took to complete).

        zstyle ':notify:*' command-complete-timeout 15

[terminal-notifier]: https://github.com/alloy/terminal-notifier 
[iterm2]: http://www.iterm2.com/
[dogefy.sh]: https://gist.github.com/marzocchi/14c47a49643389029a2026b4d4fec7ae

