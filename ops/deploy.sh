#!/usr/bin/env bash
set -ex

docker build deploy/ -f deploy/Dockerfile -t oche_deploy

AWS_ACCESS_OPTIONS="-e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY -e AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION"

docker run --rm $AWS_ACCESS_OPTIONS --entrypoint '/bin/sh' oche_deploy update_service.sh
