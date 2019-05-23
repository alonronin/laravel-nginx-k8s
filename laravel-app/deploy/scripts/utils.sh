#!/usr/bin/env bash

processes=()

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

function get_image_hash() {
    if [[ -n "${VERSION:-}" ]]; then
        echo "$VERSION"
        return
    fi

    git rev-parse --short HEAD
}
