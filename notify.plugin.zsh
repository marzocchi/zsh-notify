# vim: set nowrap filetype=zsh:
# 
# See README.md.
#
fpath=($fpath $(dirname $0:A))

zstyle ':notify:*' resources-dir $(dirname $0:A)/resources
zstyle ':notify:*' window-pid $WINDOWID

test -z "$_ZSH_NOTIFY_ROOT_PPID" && export _ZSH_NOTIFY_ROOT_PPID="$PPID"
zstyle ':notify:*' parent-pid $_ZSH_NOTIFY_ROOT_PPID

# Notify an error with no regard to the time elapsed (but always only
# when the terminal is in background).
function notify-error {
    local time_elapsed 
    time_elapsed=$1
    notify-if-background error "$time_elapsed" < /dev/stdin &!
}

# Notify of successful command termination, but only if it took at least
# 30 seconds (and if the terminal is in background).
function notify-success() {
    local time_elapsed command_complete_timeout

    time_elapsed=$1

    zstyle -s ':notify:' command-complete-timeout command_complete_timeout \
        || command_complete_timeout=30

    if (( $time_elapsed > $command_complete_timeout )); then
        notify-if-background success "$time_elapsed" < /dev/stdin &!
    fi
}

# Notify about the last command's success or failure.
function notify-command-complete() {
    last_status=$?

    local now time_elapsed

    if [[ -n $start_time ]]; then
      now=`date "+%s"`
      ((time_elapsed = $now - $start_time ))
      if [[ $last_status -gt "0" ]]; then
          notify-error "$time_elapsed" <<< $last_command
      elif [[ -n $start_time ]]; then
          notify-success "$time_elapsed" <<< $last_command
      fi
    fi
    unset last_command last_status start_time
}

function store-command-stats() {
    last_command=$1
    start_time=`date "+%s"`
}

autoload add-zsh-hook
autoload -U notify-if-background
add-zsh-hook preexec store-command-stats
add-zsh-hook precmd notify-command-complete
