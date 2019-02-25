#!/bin/bash

source VERSION

set -e

$(aws ecr get-login --no-include-email --region ap-northeast-1)

docker push $RESTY_AUTH_SERVE_IMAGE
