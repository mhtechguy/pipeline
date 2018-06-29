#!/usr/bin/env bash
[[ -n ${VERBOSE+x} ]] && set -x
set -e
for arg in "$@"; do
    pushd $arg
    eval $GRADLE --no-search-upward test
    popd
done
