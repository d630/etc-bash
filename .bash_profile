#!/usr/bin/env bash
#
# .bash_profile
#
# Read and executed by bash(1), when it is beeing started as login shell. Read
# after /etc/profile.

[[ -r $HOME/.bash_login ]] &&
    . "$HOME/.bash_login"

[[ -r $HOME/.bashrc ]] &&
    . "$HOME/.bashrc"

export BASH_ENV
BASH_ENV=.bashenv

# vim: set ft=sh :
