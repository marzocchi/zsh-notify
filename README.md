zsh-notify
=======

Desktop notifications for long running commands in ZSH.

Supported terminals and requirements
---

- On Mac OS X: Terminal.app or [iTerm2][iterm2];
- On Linux (and possibly other systems): any terminal application should be
  supported as `xdotool` and `wmctrl` are used to query and modify windows
  state.
  
When using the default notifier notifications are posted using
[terminal-notifier.app][terminal-notifier] on Mac OS X and `notify-send` on
other systems.

When using Tmux on Yosemite, `reattach-to-user-namespace` is required to
prevent terminal-notifier to hang (see
[julienXX/terminal-notifier#115][issue115] for details).

Usage
---

Just source notify.plugin.zsh.

Configuration
---

Use `zstyle` in your `~/.zshrc`.

- Set a custom title for error and success notifications, when using the
  built-in notifier.

        zstyle ':notify:*' error-title "Command failed"
        zstyle ':notify:*' success-title "Command finished"

    The string `#{time_elapsed}` will be replaced with the command run time.

        zstyle ':notify:*' error-title "Command failed (in #{time_elapsed} seconds)"
        zstyle ':notify:*' success-title "Command finished (in #{time_elapsed} seconds)"

- Change the notifications icons for failure or success. Any image path or URL
  (Mac OS only) should work.
        
        zstyle ':notify:*' error-icon "/path/to/error-icon.png"
        zstyle ':notify:*' success-icon "/path/to/success-icon.png"
    
    [Try this][dogefy.sh]. Wow.

- Set a sound for error and success notifications, when using the built-in
  notifier. On Linux you should specify the path to an audio file.

        zstyle ':notify:*' error-sound "Glass"
        zstyle ':notify:*' success-sound "default"

- Have the terminal come back to front when the notification is posted.

        zstyle ':notify:*' activate-terminal yes

- Disable setting the urgency hint for the terminal when the notification is
  posted (Linux only).

        zstyle ':notify:*' disable-urgent yes

- Set a different timeout for notifications for successful commands
  (notifications for failed commands are always posted).

        zstyle ':notify:*' command-complete-timeout 15

- Replace the built-in notifier with a custom one at `~/bin/my-notifier`. The
  custom notifier will receive the notification type (`error` or `success`) as
  the first argument, the time elapsed as the second argument, and the
  command line as standard input.

        zstyle ':notify:*' notifier ~/bin/my-notifier

- Disable error reporting (or send it somewhere else)

        zstyle ':notify:*' error-log /dev/null

[terminal-notifier]: https://github.com/alloy/terminal-notifier 
[iterm2]: http://www.iterm2.com/
[dogefy.sh]: https://gist.github.com/marzocchi/14c47a49643389029a2026b4d4fec7ae
[issue115]: https://github.com/julienXX/terminal-notifier/issues/115

## Installation

### [Antigen](https://github.com/zsh-users/antigen)

Add `antigen bundle marzocchi/zsh-notify` to your `.zshrc` with your other
bundle commands.

Antigen will handle cloning the plugin for you automatically the next time you
start zsh. You can also add the plugin to a running zsh with `antigen bundle
marzocchi/zsh-notify` for testing before adding it to your `.zshrc`.

### [Oh-My-Zsh](http://ohmyz.sh/)

1. `git clone git@github.com:marzocchi/zsh-notify.git ~/.oh-my-zsh/custom/plugins/notify`
2. Add zsh-notify to your plugin list - edit `~./zshrc` and change `plugins=(...)` to `plugins=(... notify)`

**Note:** when cloning, specify the target directory as `notify` since
Oh-My-Zsh expects the plugin's initialization file to have the same name as
it's directory.

### [Zgen](https://github.com/tarjoilija/zgen)

Add `zgen load marzocchi/zsh-notify` to your .zshrc file in the same function
you're doing your other `zgen load` calls in.
