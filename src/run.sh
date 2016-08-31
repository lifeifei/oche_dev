#!/usr/bin/env bash

set -ex
COMPOSE_PROJECT=oche

cleanup() {
  docker-compose -p $COMPOSE_PROJECT stop
  docker-compose -p $COMPOSE_PROJECT rm -f -v
}
trap cleanup EXIT
cleanup

docker-compose -p $COMPOSE_PROJECT up