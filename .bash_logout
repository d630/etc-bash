#!/usr/bin/env bash
#
# .bash_logout
#
# Read and executed by bash(1), when login shells exit. Read after
# /etc/bash.bash_logout.

shopt -q login_shell && {
    if
        [[ -z $SSH_CLIENT$SSH_CONNECTION$SSH_TTY ]];
    then
        set +o history &&
            HISTFILE=$HISTFILE bash-dedup-history;
        d=${XDG_BACKUP_HOME:-/home/files/var/backups}/bash;
        alias -p > "$d/"alias.log;
        bind -X > "$d/"bind-key-x-macros.log;
        bind -p > "$d/"bind-functions.log;
        bind -s > "$d/"bind-key-macros.log;
        bind -v > "$d/"bind-variables.log;
        complete -p > "$d/"completions.log;
        builtins > "$d/"builtins.log;
        functions > "$d/"functions.log;
    else
        printf %s\\n Bye-bye! 1>&2;
    fi;

    /bin/fgconsole 1>/dev/null 2>&1 &&
        /usr/bin/clear &&
            /usr/bin/reset;
    #clear_console -q;
};

# vim: set ft=sh :
