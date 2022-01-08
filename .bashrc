#!/usr/bin/env bash
#
# .bashrc
#
# Read and executed by bash(1), when an interactive non-login shell is beeing
# started. Read after /etc/bash.bashrc.

#BASH_COMPAT=
#POSIXLY_CORRECT=
#set -o posix
#set -o privileged
#shopt -s login_shell
#shopt -s restricted_shell
#shopt -u compat31
#shopt -u compat32
#shopt -u compat40
#shopt -u compat41
#shopt -u compat42

#BASH_XTRACEFD=
#set -o errexit
#set -o errtrace
#set -o functrace
#set -o noexec
#set -o onecmd
#set -o verbose
#set -o xtrace
#shopt -s extdebug

[[ $- == *i* ]] ||
    return 1

[[ -z ${debian_chroot:-} && -r /etc/debian_chroot ]] &&
    debian_chroot=$(</etc/debian_chroot)

. "$HOME/.profile.d/ext.sh"
. "$HOME/.profile.d/base.sh"
. "$HOME/.profile.d/run.sh"

. "$HOME/.bashrc.d/ext.bash"

. "$HOME/.bashrc.d/base.bash"
\BashRcBaseEditing
\BashRcBaseJobcontrol
\BashRcBaseTerminfo
\BashRcBaseExpansion
\BashRcBaseMisc
\BashRcExtBpx
\BashRcBasePrompting
#\BashRcBaseBuiltin;

unalias -a
\BashRcBaseAlias

complete -r
\BashRcBaseCompletion

. "$HOME/.bashrc.d/function.bash"

\BashRcExtKeychain
\BashRcExtGpg
\BashRcExtLs
\BashRcExtZ
\BashRcExtFzf
\BashRcExtPyenv

\BashRcExtBma

\BashRcBaseHistory

# vim: set ft=sh :
