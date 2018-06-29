#!/usr/bin/env bash
[[ -n ${VERBOSE+x} ]] && set -x
set -e
set -o pipefail
for arg in "$@"; do
    pushd $arg >/dev/null
    eval $MVN clean verify | eval $MVN_LOG
    popd >/dev/null
done
