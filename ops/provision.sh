#!/usr/bin/env bash
set -ex

AWS_ACCESS_OPTIONS="-e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY -e AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION"

docker run --rm $AWS_ACCESS_OPTIONS -v $PWD/terraform/provision:/root -w="/root" --entrypoint '/bin/terraform' hashicorp/terraform:0.7.2 plan
