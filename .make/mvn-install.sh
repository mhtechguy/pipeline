#!/usr/bin/env bash
[[ -n ${VERBOSE+x} ]] && set -x
set -e
set -o pipefail
shopt -s nocasematch

if [ "$1" == "--dry-run" ]; then
    shift
    if [[ "${HOST_PLATFORM}" == "batch" ]]; then
        for arg in "$@"; do
            echo pushd $arg
            echo mvn clean install -DskipTests -Dinvoker.skip=true
            echo popd
        done
    else
        exit 1
    fi
else
    if [[ -z ${HOST_PLATFORM} ]]; then
        for arg in "$@"; do
            pushd $arg >/dev/null
            eval $MVN clean install -DskipTests -Dinvoker.skip=true | eval $MVN_LOG
            popd >/dev/null
        done
    else
        exit 1
    fi
fi

