#!/usr/bin/env bash

set -e
set -o pipefail
set -u
set -o posix

cd "$(dirname "$0")"
. ./deploy/scripts/utils.sh

export hash="$(get_image_hash)"

function kubectl_apply() {
    for file in "$@"; do
        cat "$file" | envsubst | tee /dev/stderr | kubectl apply -f -
    done
}

kubectl_apply deploy/kube/*.yaml
