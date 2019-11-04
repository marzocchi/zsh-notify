# vim: set nowrap filetype=zsh:

plugin_dir="$(dirname $0:A)"

if [[ "$TERM_PROGRAM" == 'iTerm.app' ]]; then
  impl=applescript
elif [[ "$TERM_PROGRAM" == 'Apple_Terminal' ]]; then
  impl=applescript
elif [[ "$DISPLAY" != '' ]] && command -v xdotool > /dev/null 2>&1 &&  command -v wmctrl > /dev/null 2>&1; then
  impl=xdotool
else
  echo "zsh-notify: unsupported environment" >&1
  return
fi

fpath=($fpath "$plugin_dir"/"$impl")

zstyle ':notify:*' plugin-dir "$plugin_dir"
zstyle ':notify:*' impl "$impl"
zstyle ':notify:*' command-complete-timeout 30
zstyle ':notify:*' error-log /dev/stderr
zstyle ':notify:*' notifier zsh-notify
zstyle ':notify:*' success-title '#win (in #{time_elapsed})'
zstyle ':notify:*' success-sound ''
zstyle ':notify:*' success-icon ''
zstyle ':notify:*' error-title '#fail (in #{time_elapsed})'
zstyle ':notify:*' error-sound ''
zstyle ':notify:*' error-icon ''
zstyle ':notify:*' disable-urgent no
zstyle ':notify:*' activate-terminal no
zstyle ':notify:*' always-check-active-window no

unset plugin_dir
unset impl

# NOTE: Using the initial `WINDOWID` value can result in false negatives with
# tmux, i.e. it can return that the terminal window is inactive even when it's
# active. Steps to reproduce:
# 1. Open terminal window with tmux session S
# 2. Open another terminal window and attach to session S
# 3. Type in the original terminal the command:
#    `zstyle ':notify:*' command-complete-timeout 1; sleep 2`
#
# Why does this happen?
# When the new terminal window is opened, tmux updates the session environment
# variable `WINDOWID` to match the new window. When a new shell is started in
# the session (in any terminal window), it will inherit this value. So now the
# WINDOWID will only be correct for new shells in the new window, or for
# existing shells in the previous window, but in all other cases it will be
# incorrect.
if [[ "$WINDOWID" != "" ]]; then
    zstyle ':notify:*' window-id "$WINDOWID"
fi

# store command line and start time for later
function zsh-notify-before-command() {
    local window_id impl
    local window_id impl always_check_wid

    last_command="$1"
    start_time=$(date "+%s")

    zstyle -s ':notify:' window-id window_id
    zstyle -s ':notify:' impl impl
    zstyle -s ':notify:' always-check-active-window always_check_wid

    # workaround the lack of $WINDOWID in gnome-terminal and possibly other
    # linux terms by capturing the ID of the window that is _now_ focused (eg.
    # it's the one the user typed a command).
    if [[ "$impl" == xdotool && ("$window_id" == "" || always_check_wid == "yes") ]]; then
        zstyle ':notify:*' window-id "$(xdotool getwindowfocus)"
    fi
}

# notify about the last command's success or failure -- maybe.
function zsh-notify-after-command() {
    last_status=$?

    local now time_elapsed error_log command_complete_timeout notifier

    zstyle -s ':notify:' error-log error_log 
    zstyle -s ':notify:' command-complete-timeout command_complete_timeout 
    zstyle -s ':notify:' notifier notifier

    (
      if [[ -n $start_time ]]; then
          now=$(date "+%s")
          (( time_elapsed = now - start_time ))
          if [[ $last_status -gt "0" ]]; then
              is-terminal-active || "$notifier" error "$time_elapsed" <<< "$last_command"
          elif [[ -n $start_time ]]; then
              if (( time_elapsed > command_complete_timeout )); then
                is-terminal-active || "$notifier" success "$time_elapsed" <<< "$last_command"
              fi
          fi
      fi
    )  2>&1 | sed 's/^/zsh-notify: /' > "$error_log"

    unset last_command last_status start_time
}

autoload add-zsh-hook
autoload -U is-terminal-active
autoload -U zsh-notify
add-zsh-hook preexec zsh-notify-before-command
add-zsh-hook precmd zsh-notify-after-command
