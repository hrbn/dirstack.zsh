setopt autopushd pushdminus pushdsilent pushdtohome pushd_ignore_dups

DIRSTACKSIZE=${DIRSTACKSIZE:-32}
DIRSTACKFILE=${DIRSTACKFILE:-${XDG_CACHE_HOME:-${HOME}/.cache}/zdirs}

typeset -gaU PERSISTENT_DIRSTACK

function chpwd () {
    (( ZSH_SUBSHELL )) && return
    (( $DIRSTACKSIZE <= 0 )) && return
    [[ -z $DIRSTACKFILE ]] && return
    PERSISTENT_DIRSTACK=(
        $PWD "${(@)PERSISTENT_DIRSTACK[1,$DIRSTACKSIZE]}"
    )
    builtin print -l ${PERSISTENT_DIRSTACK} >! ${DIRSTACKFILE}
}

if [[ -f ${DIRSTACKFILE} ]]; then
    dirstack=( ${(f)"$(< $DIRSTACKFILE)"}(N) )
    [[ -d $dirstack[1] ]] && cd -q $dirstack[1] && cd -q $OLDPWD
fi

PERSISTENT_DIRSTACK=( "${dirstack[@]}" )
