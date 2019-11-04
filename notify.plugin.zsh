# vim: set nowrap filetype=zsh:

plugin_dir="$(dirname $0:A)"

_USING_XDOTOOL=0
if [[ "$TERM_PROGRAM" == 'iTerm.app' ]]; then
    source "$plugin_dir"/applescript/functions
elif [[ "$TERM_PROGRAM" == 'Apple_Terminal' ]]; then
    source "$plugin_dir"/applescript/functions
elif [[ "$DISPLAY" != '' ]] && command -v xdotool > /dev/null 2>&1 &&  command -v wmctrl > /dev/null 2>&1; then
    _USING_XDOTOOL=1
    source "$plugin_dir"/xdotool/functions
else
    echo "zsh-notify: unsupported environment" >&1
    return
fi

fpath=($fpath)

zstyle ':notify:*' plugin-dir "$plugin_dir"
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

# store command line and start time for later
function zsh-notify-before-command() {
    local window_id always_check_wid

    last_command="$1"
    start_time=$(date "+%s")

    if [[ "$_USING_XDOTOOL" == 1 &&
        ("$window_id" == "" || always_check_wid == "yes") ]]; then
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

add-zsh-hook preexec zsh-notify-before-command
add-zsh-hook precmd zsh-notify-after-command
