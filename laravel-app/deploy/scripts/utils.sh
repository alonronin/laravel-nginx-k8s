#!/usr/bin/env bash

processes=()
trap kill_all EXIT

function start() {
    "$@" &
    processes+=($!)
}

function wait_all() {
    for p in "${processes[@]}"; do
        wait "$p"
    done
    processes=()
}

function kill_all() {
    if [[ "${#processes[@]}" -gt 0 ]]; then
        kill "${processes[@]}"
    fi
}

function get_image_hash() {
    if [[ -n "${VERSION:-}" ]]; then
        echo "$VERSION"
        return
    fi

    git rev-parse --short HEAD
}
