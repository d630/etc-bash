#!/usr/bin/env bash
#
# functions.

up() {
    if [[ -z ${1//[0-9]/} ]]; then
        declare s
        printf -v s "%${1:-1}s"
        builtin -- cd -- "${s// /..\/}"
    else
        echo 'Usage: up [ <INT> ]' 1>&2
        return 1
    fi
}

sup() {
    if [[ -z ${1//[0-9]/} ]]; then
        pushd "+${1:-2}"
    else
        echo 'Usage: sup [ <INT> ]' 1>&2
        return 1
    fi
}

mcd() {
    if (($#)); then
        command -- /bin/mkdir -pv -- "$1" &&
            builtin -- cd -- "$1"
    else
        echo 'Usage: mcd <dir>' 1>&2
        return 1
    fi
}

scd() {
    declare dir
    read -r _ dir < <(
        dirs -l -v |
            exec -- "$XDG_BIN_HOME/menu" fzf cd
    )

    if [[ -d $dir ]]; then
        builtin -- cd -- "$dir"
    else
        echo 'No dir has been chosen' 1>&2
        return 1
    fi
}

setenv() {
    declare -gx "$1=$2"
}

setvar() {
    declare -g "$1=$2"
}

function @ {
    (($*))
}

defn() {
    case $1 in
        ?*\[[@\*]\]*)
            eval "${1//\[[@\*]\]/}"'=("${@:2}")'
            ;;
        ?*)
            eval "${1//\[[@\*]\]/}"'="${*:2}"'
            ;;
        *)
            ! :
            ;;
    esac
}

undefn() {
    for __ in "$@"; do
        case $__ in
            ?*\[[@\*]\]*)
                eval "${__//\[[@\*]\]/}"'=()'
                ;;
            ?*)
                eval "${__/%/=}"
                ;;
            *)
                return 1
                ;;
        esac
    done
}

list() {
    printf "${2:-%b\n}" "${!1}"
}

function list! {
    eval printf "${2:-%b\\\n}" '"${'"!${1%%[*}[@]"'}"'
}

san() {
    case $1 in
        -[fn])
            unset "$@"
            ;;
        *)
            unset -v "$@"
            ;;
    esac
}

glob() {
    declare IFS
    IFS=
    printf %s\\0 "$*"
}

ashift() {
    declare -n ref
    ref=$1
    ref=("${ref[@]:(${2:-0})}")
}

dequote() {
    eval printf %s "$1" 2>/dev/null
}

defer() {
    if ! ((${#Defer[@]})); then
        trap '
            if [[ $FUNCNAME != defer ]]; then
                for ((i = ${#Defer[@]} - 1; i > -1; i--)); do
                    eval "${Defer[i]}"
                done
                unset -v Defer i
                trap - RETURN
            fi
        ' RETURN
    fi

    Defer+=("$*")
}

debug_set_x() {
    case $1 in
        '')
            ! :
            ;;
        -)
            set -x
            ;;
        +)
            set +x
            exec 4>&-
            unset -v BASH_XTRACEFD
            ;;
        *)
            exec 4>>"$1"
            BASH_XTRACEFD=4
            set -x
            ;;
    esac
}

toggle_options() {
    declare b o n

    while read -r b o n _; do
        case $b$o in
            set+o) set -o "$n" ;;
            set-o) set +o "$n" ;;
            shopt-s) shopt -u "$n" ;;
            shopt-u) shopt -s "$n" ;;
        esac
    done < <(
        bold=$'\e[1m'
        green=$'\e[32m'
        red=$'\e[31m'
        reset=$'\e[0m'

        {
            shopt -p
            shopt -op
        } |
            exec -- /bin/sed "
                / -[so] / {
                    s/$/ ${bold}${green}enabled${reset}/;
                    b;
                };
                {
                    s/$/ ${bold}${red}disabled${reset}/;
                };
            " |
            exec -- /usr/bin/sort -k 3 |
            exec -- /usr/bin/column -t |
            exec -- /usr/bin/fzf --height 40% --ansi --multi --with-nth=3.. \
                --tiebreak=begin --reverse
    )
}

function !=? [[ ${1?} != "${2?}" ]]
function !=~? [[ ! ${1?} =~ "${2?}" ]]
function +? [[ ${1?} > ${2?} ]]
function -? [[ ${1?} < ${2?} ]]
function ==? [[ ${1?} == "${2?}" ]]
function =~? [[ ${1?} =~ "${2?}" ]]
function G? [[ -G ${1?} ]]
function L? [[ -L ${1?} ]]
function N? [[ -N ${1?} ]]
function O? [[ -O ${1?} ]]
function R? [[ -R ${1?} ]]
function S? [[ -S ${1?} ]]
function b? [[ -b ${1?} ]]
function c? [[ -c ${1?} ]]
function d? [[ -d ${1?} ]]
function e? [[ -e ${1?} ]]
function ef? [[ ${1?} -ef ${2?} ]]
function eq? [[ ${1?} -eq ${2?} ]]
function f? [[ -f ${1?} ]]
function g? [[ -g ${1?} ]]
function ge? [[ ${1?} -ge ${2?} ]]
function gt? [[ ${1?} -gt ${2?} ]]
function k? [[ -k ${1?} ]]
function le? [[ ${1?} -le ${2?} ]]
function lt? [[ ${1?} -lt ${2?} ]]
function n? [[ -n ${1?} ]]
function ne? [[ ${1?} -ne ${2?} ]]
function nt? [[ ${1?} -nt ${2?} ]]
function o? [[ -o ${1?} ]]
function ot? [[ ${1?} -ot ${2?} ]]
function p? [[ -p ${1?} ]]
function r? [[ -r ${1?} ]]
function s? [[ -s ${1?} ]]
function t? [[ -t ${1?} ]]
function u? [[ -u ${1?} ]]
function v? [[ -v ${1?} ]]
function w? [[ -w ${1?} ]]
function x? [[ -x ${1?} ]]
function z? [[ -z ${1?} ]]

# vim: set ft=sh :
