#!/usr/bin/env bash

set -e
set -o pipefail
set -u
set -o posix

cd "$(dirname "$0")"
. ./deploy/scripts/utils.sh

hash="$(get_image_hash)"

php_image="alonronin/php-fpm:php-${hash}"
nginx_image="alonronin/php-fpm:nginx-${hash}"

start docker build . -f deploy/dockerfiles/php.Dockerfile -t "$php_image"
start docker build . -f deploy/dockerfiles/nginx.Dockerfile -t "$nginx_image"

wait_all

start docker push "$php_image"
start docker push "$nginx_image"

wait_all

echo "Built $php_image and $nginx_image"
