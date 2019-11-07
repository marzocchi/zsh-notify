# vim: set nowrap filetype=zsh:

plugin_dir="$(dirname $0:A)"

if [[ "$TERM_PROGRAM" == 'iTerm.app' ]]; then
    source "$plugin_dir"/applescript/functions
elif [[ "$TERM_PROGRAM" == 'Apple_Terminal' ]]; then
    source "$plugin_dir"/applescript/functions
elif [[ "$DISPLAY" != '' ]] && command -v xdotool > /dev/null 2>&1 &&  command -v wmctrl > /dev/null 2>&1; then
    source "$plugin_dir"/xdotool/functions
else
    echo "zsh-notify: unsupported environment" >&1
    return
fi

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
zstyle ':notify:*' blacklist-regex ''
zstyle ':notify:*' enable-on-ssh no

unset plugin_dir

function _zsh-notify-is-command-blacklisted() {
    local blacklist_regex
    zstyle -s ':notify:*' blacklist-regex blacklist_regex
    if [[ -z "$blacklist_regex" ]]; then
        return 1
    fi
    print -rn -- "$last_command" | grep -q -E "$blacklist_regex"
}

function _zsh-notify-is-ssh() {
    [[ -n ${SSH_CLIENT-} || -n ${SSH_TTY-} || -n ${SSH_CONNECTION-} ]]
}

function _zsh-notify-should-notify() {
    local last_status="$1"
    local time_elapsed="$2"
    if [[ -z $start_time ]] || _zsh-notify-is-command-blacklisted; then
        return 1
    fi
    local enable_on_ssh
    zstyle -b ':notify:*' enable-on-ssh enable_on_ssh
    if _zsh-notify-is-ssh && [[ $enable_on_ssh == 'no' ]]; then
        return 2
    fi
    if ((last_status == 0)); then
        local command_complete_timeout
        zstyle -s ':notify:*' command-complete-timeout command_complete_timeout
        if (( time_elapsed < command_complete_timeout )); then
            return 3
        fi
    fi
    # this is the last check since it will be the slowest if
    # `always-check-active-window` is set.
    if is-terminal-active; then
        return 4
    fi
    return 0
}

# store command line and start time for later
function zsh-notify-before-command() {
    declare -g last_command="$1"
    declare -g start_time
    start_time="$(date "+%s")"
}

# notify about the last command's success or failure -- maybe.
function zsh-notify-after-command() {
    local last_status=$?

    local error_log notifier now time_elapsed

    zstyle -s ':notify:' error-log error_log 
    zstyle -s ':notify:' notifier notifier

    touch "$error_log"
    (
        now="$(date "+%s")"
        (( time_elapsed = now - start_time ))
        if _zsh-notify-should-notify "$last_status" "$time_elapsed"; then
            local result
            result="$(((last_status == 0)) && echo success || echo error)"
            "$notifier" "$result" "$time_elapsed" <<< "$last_command"
        fi
    )  2>&1 | sed 's/^/zsh-notify: /' >> "$error_log"

    unset last_command start_time
}

autoload -U add-zsh-hook
add-zsh-hook preexec zsh-notify-before-command
add-zsh-hook precmd zsh-notify-after-command
