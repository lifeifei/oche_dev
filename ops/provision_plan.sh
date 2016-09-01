#!/usr/bin/env bash
set -ex

AWS_ACCESS_OPTIONS="-e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY -e AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION"

: ${SSH_KEY_NAME?"Please set ssh key name"}

TASK=plan
[ -n "${APPLY}" ] && TASK=apply

docker run --rm $AWS_ACCESS_OPTIONS -v $PWD/terraform:/root -w="/root/$1" --entrypoint '/bin/ash' hashicorp/terraform:0.7.2 -c "terraform $TASK -var 'ssh_key_name=$SSH_KEY_NAME'"
