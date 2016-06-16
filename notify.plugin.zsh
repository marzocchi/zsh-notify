# vim: set nowrap filetype=zsh:
# 
# See README.md.
#
fpath=($fpath $(dirname $0:A))

zstyle ':notify:*' resources-dir $(dirname $0:A)/resources
zstyle ':notify:*' parent-pid $PPID

# Notify an error with no regard to the time elapsed (but always only
# when the terminal is in background).
function notify-error {
    notify-if-background error < /dev/stdin &!
}

# Notify of successful command termination, but only if it took at least
# 30 seconds (and if the terminal is in background).
function notify-success() {
    local now diff start_time last_command command_complete_timeout

    start_time=$1
    last_command="$2"
    now=`date "+%s"`

    zstyle -s ':notify:' command-complete-timeout command_complete_timeout \
        || command_complete_timeout=30

    ((diff = $now - $start_time ))
    if (( $diff > $command_complete_timeout )); then
        notify-if-background success <<< "$last_command" &!
    fi
}

# Notify about the last command's success or failure.
function notify-command-complete() {
    last_status=$?
    if [[ $last_status -gt "0" ]]; then
        notify-error <<< $last_command
    elif [[ -n $start_time ]]; then
        notify-success "$start_time" "$last_command"
    fi
    unset last_command start_time last_status
}

function store-command-stats() {
    last_command=$1
    last_command_name=${1[(wr)^(*=*|sudo|ssh|-*)]}
    start_time=`date "+%s"`
}

if [[ -z "$PPID_FIRST" ]]; then
  export PPID_FIRST=$PPID
fi

autoload add-zsh-hook
autoload -U notify-if-background
add-zsh-hook preexec store-command-stats
add-zsh-hook precmd notify-command-complete
