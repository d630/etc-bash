#!/usr/bin/env bash
#
# BashRcEnvBase.

BashRcBaseAlias() {
    shopt -s expand_aliases
    \ProfileRcBaseAlias

    alias -- '-=builtin cd -- -'
    alias 'array=declare -a'
    alias 'builtins=compgen -b'
    alias 'bye=logout'
    alias 'dedup=bash-dedup-history'
    alias 'functions=declare -f'
    alias 'iarray=declare -ai'
    alias 'integer=declare -i'
    alias 'itable=declare -Ai'
    alias 'j=jobs -l'
    alias 'nameref=declare -n'
    alias 'neustart=builtin -- cd;. .bash_logout; /usr/bin/sudo /bin/systemctl reboot'
    alias 'prompt-default=\BashRcBasePrompting'
    alias "prompt-simple=PROMPT_COMMAND= PS1='\u@\h \w \$ ' PS2='> ' PS3= PS4='+ '"
    alias 'r=pushd +1 1>/dev/null;popd'
    alias 'rehash=hash -r'
    alias 'rreload=builtin -- cd; /usr/bin/xrdb -merge .Xresources'
    alias 'runter=builtin -- cd;. .bash_logout; /usr/bin/sudo /bin/systemctl poweroff'
    alias 'so={ ((!$?)); }'
    alias 'table=declare -A'
    alias 'urm=builtin -- cd .. && echo "$PWD" 1>&2 && /bin/rm -rfI -- "$OLDPWD"'
}

BashRcBaseBuiltin() {
    declare x

    for x in /usr/lib/bash "$HOME/lib/bash"; do
        if [[ -d $x ]]; then
            BASH_LOADABLES_PATH=$x${BASH_LOADABLES_PATH+:$BASH_LOADABLES_PATH}
        fi
    done

    #mypid
    for x in fdflags finfo print push setpgid strftime; do
        enable -f "$x" "$x"
    done
}

BashRcBaseCompletion() {
    shopt -s complete_fullquote
    shopt -s direxpand
    shopt -s dirspell
    shopt -s force_fignore
    shopt -s hostcomplete
    shopt -s no_empty_cmd_completion
    shopt -s progcomp
    shopt -u progcomp_alias
    unset -v COMPREPLY
    unset -v FIGNORE
    unset -v HOSTFILE

    # complete -A alias alias unalias;
    # complete -A arrayvar array iarray itable table;
    # complete -A binding bind;
    # complete -A builtin builtin;
    # complete -A command command type which;
    complete -A directory pushd . source cd
    # complete -A disabled enable;
    # complete -A enabled enable;
    # complete -A export export;
    # complete -A file . source;
    # complete -A helptopic help;
    # complete -A job -P \"% -S \" fg jobs disown;
    # complete -A setopt set;
    # complete -A shopt shopt;
    # complete -A stopped -P \"% -S \" bg;
    # complete -A user groups
    # complete -A variable readonly unset;

    if [[ -r /usr/share/bash-completion/bash_completion ]]; then
        . /usr/share/bash-completion/bash_completion
    elif [[ -r /etc/bash_completion ]]; then
        . /etc/bash_completion
    fi

    . /etc/bash_completion.d/git-prompt
}

BashRcBaseEditing() {
    #EMACS=
    #vi
    set -o emacs
}

BashRcBaseExpansion() {
    set +o noglob
    set +o nounset
    set -o braceexpand
    shopt -s dotglob
    shopt -s extglob
    shopt -s extquote
    shopt -s globstar
    shopt -u failglob
    shopt -u globasciiranges
    shopt -u nocaseglob
    shopt -u nocasematch
    shopt -u nullglob
    unset -v GLOBIGNORE
}

BashRcBaseHistory() {
    HISTCONTROL=
    HISTFILE=${XDG_VAR_HOME:?}/spool/bash_history
    HISTFILESIZE=-1
    HISTIGNORE=
    HISTSIZE=-1
    histchars=\!^\#

    # shopt -u syslog_history;
    set -o histexpand
    set -o history
    shopt -s cmdhist
    shopt -s histappend
    shopt -s histreedit
    shopt -s histverify
    shopt -u lithist
    unset -v HISTTIMEFORMAT
}

BashRcBaseJobcontrol() {
    set -o monitor
    set +o notify
    shopt -s checkjobs
    shopt -u huponexit
    shopt -u lastpipe
    unset -v auto_resume
}

BashRcBaseMisc() {
    FUNCNEST=0
    TIMEFORMAT=$'\nreal\t%3lR\nuser\t%3lU\nsys \t%3lS'

    set +o ignoreeof
    set +o keyword
    set +o noclobber
    set +o physical
    set +o pipefail
    set -o hashall
    shopt -s assoc_expand_once
    shopt -s autocd
    shopt -s cdable_vars
    shopt -s cdspell
    shopt -s checkhash
    shopt -s checkwinsize
    shopt -s inherit_errexit
    shopt -s interactive_comments
    shopt -s shift_verbose
    shopt -s sourcepath
    shopt -u execfail
    shopt -u gnu_errfmt
    shopt -u localvar_inherit
    shopt -u localvar_unset
    shopt -u mailwarn
    shopt -u xpg_echo
    unset -v CDPATH
    unset -v CHILD_MAX
    unset -v COLUMNS
    unset -v EXECIGNORE
    unset -v IGNOREEOF
    unset -v TMOUT

    function command_not_found_handle() {
        if [[ -t 2 ]]; then
            # TI_RED_F_BOLD %s TI_SGR0
            printf '\e[1m\e[31m%s\e[0m\n' uups\!
        else
            printf "%s\n" uups\!
        fi 1>&2
        return 127
    }
}

BashRcBasePrompting() {
    shopt -s promptvars
    PROMPT_DIRTRIM=12

    function __prompt_command() {
        history -a
        history -c
        history -r

        declare -g -a runningj stoppedj
        mapfile -t runningj < <(jobs -pr)
        mapfile -t stoppedj < <(jobs -ps)

        if [[ "$PWD" == "$OLDPWD" || ~1 == "$OLDPWD" ]]; then
            return
        fi

        printf '%s\n' "$PWD"
        pushd -n "$OLDPWD" 1>/dev/null 2>&1
        \_z --add "$PWD" 2>/dev/null
    }

    declare -g -i lsc

    PS1='\# $SHLVL ${_[${#runningj[@]} + ${#stoppedj[@]} != 0 ? 0 : 1]:+\[\e[33m\]${#runningj[@]}& ${#stoppedj[@]}z \[\e[0m\]}'
    PS1+='${lsc[bpx_var=0, bpx_var[2]=0, $? ? lsc=$?,0 : 1]:+\[\e[31m\](${PIPESTATUS[*]},$lsc) \[\e[0m\]}% \[\e[0m\]'
    PS2='${bpx_var[bpx_var+=1, 0]}> '
    PS3=
    PS4='+($?) ${BASH_SOURCE:-$0}:$FUNCNAME:$LINENO:'

    prompt_functions[0]=__prompt_command
    PROMPT_COMMAND=\\__bpx_hook_prompt

    bind 'C-j: "\C-x\C-x1"'
}

BashRcBaseTerminfo() {
    command -- /bin/stty -ixon -ctlecho
    command -- /usr/bin/tabs -4
}

# vim: set ft=sh :
