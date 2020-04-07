#!/usr/bin/env bash

set -e
use_tag="rontype1/uwsgi-nginx:$NAME"
docker build -t "$use_tag" "$BUILD_PATH"
docker push "$use_tag"
