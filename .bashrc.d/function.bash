#!/usr/bin/env bash
#
# functions.

function lan-up {
    sudo "$XDG_BIN_HOME/"network-device \e -c;
};

function lan-down {
    sudo "$XDG_BIN_HOME/"network-device \e -d;
};

function wlan-up {
    sudo "$XDG_BIN_HOME/"network-device \w -c;
};

function wlan-down {
    sudo "$XDG_BIN_HOME/"network-device \w -d;
};

function up
if
    [[ -z ${1//[0-9]/} ]];
then
    declare s;
    printf -v s '%*s' ${1:-1} '';
    cd -- ${s// /..\/} &&
        printf 'cd %s %s\n' -- "$PWD" 1>&2;
else
    printf %s\\n 'Usage: up [ <INT> ]' 1>&2;
    return 1;
fi;

function sup
if
    [[ -z ${1//[0-9]/} ]];
then
    pushd +"${1:-2}";
else
    printf %s\\n 'Usage: sup [ <INT> ]' 1>&2;
    return 1;
fi;

function mcd
if
    (($#));
then
    /bin/mkdir -pv -- "$1" &&
        builtin cd -- "$1" &&
            printf 'cd -- %s\n' "$PWD" 1>&2;
else
    printf '%s\n' 'Usage: mcd <dir>' 1>&2;
    return 1;
fi;

function scd {
    declare dir;
    read -r _ dir < <(
        dirs -v |
        "$XDG_BIN_HOME/"menu fzf CD;
    );
    dir=$dir/\~/$HOME};

    if
        [[ -d $dir ]];
    then
        builtin cd -- "$dir" &&
            printf 'cd -- %s\n' "$PWD" 1>&2;
    else
        printf %s\\n 'No dir has been chosen' 1>&2;
        return 1;
    fi;
};

function setenv {
    declare -gx "$1=$2";
};

function setvar {
    declare -g "$1=$2";
};

function @ (($*));

function defn
case $1 in
    (?*\[[@\*]\]*)
        eval "${1//\[[@\*]\]/}"'=("${@:2}")';;
    (?*)
        eval "${1//\[[@\*]\]/}"'="${*:2}"';;
    (*)
        ! :;;
esac;

function undefn
for __; do
    case $__ in
        (?*\[[@\*]\]*)
            eval "${__//\[[@\*]\]/}"'=()';;
        (?*)
            eval "${__/%/=}";;
        (?*)
            ! :;;
    esac;
done;

function list {
    printf "${2:-%b\n}" "${!1}";
};

function list! {
    eval printf "${2:-%b\\\n}" '"${'"!${1%%[*}[@]"'}"';
};

function san
case $1 in
    (\-[fn])
        unset "$@";;
    (*)
        unset -v "$@";;
esac;

function glob () {
    declare IFS;
    IFS=;
    printf %s\\0 "$*";
};

function ashift {
    declare -n "ref=$1";
    ref=("${ref[@]:(${2})}");
};

function dequote {
    eval printf %s "$1" 2>/dev/null;
};

function !=? [[ ${1?} != "${2?}" ]];
function !=~? [[ ! ${1?} =~ "${2?}" ]];
function +? [[ ${1?} > ${2?} ]];
function -? [[ ${1?} < ${2?} ]];
function ==? [[ ${1?} == "${2?}" ]];
function =~? [[ ${1?} =~ "${2?}" ]];
function G? [[ -G ${1?} ]];
function L? [[ -L ${1?} ]];
function N? [[ -N ${1?} ]];
function O? [[ -O ${1?} ]];
function R? [[ -R ${1?} ]];
function S? [[ -S ${1?} ]];
function b? [[ -b ${1?} ]];
function c? [[ -c ${1?} ]];
function d? [[ -d ${1?} ]];
function e? [[ -e ${1?} ]];
function ef? [[ ${1?} -ef ${2?} ]];
function eq? [[ ${1?} -eq ${2?} ]];
function f? [[ -f ${1?} ]];
function g? [[ -g ${1?} ]];
function ge? [[ ${1?} -ge ${2?} ]];
function gt? [[ ${1?} -gt ${2?} ]];
function k? [[ -k ${1?} ]];
function le? [[ ${1?} -le ${2?} ]];
function lt? [[ ${1?} -lt ${2?} ]];
function n? [[ -n ${1?} ]];
function ne? [[ ${1?} -ne ${2?} ]];
function nt? [[ ${1?} -nt ${2?} ]];
function o? [[ -o ${1?} ]];
function ot? [[ ${1?} -ot ${2?} ]];
function p? [[ -p ${1?} ]];
function r? [[ -r ${1?} ]];
function s? [[ -s ${1?} ]];
function t? [[ -t ${1?} ]];
function u? [[ -u ${1?} ]];
function v? [[ -v ${1?} ]];
function w? [[ -w ${1?} ]];
function x? [[ -x ${1?} ]];
function z? [[ -z ${1?} ]];

# vim: set ft=sh :
