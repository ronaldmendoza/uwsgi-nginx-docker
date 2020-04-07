#!/usr/bin/env bash

set -e

use_tag="rontype1/uwsgi-nginx:$NAME"
use_dated_tag="${use_tag}-$(date -I)"

docker build -t "$use_tag" "$BUILD_PATH"

docker tag "$use_tag"

docker push "$use_tag"
