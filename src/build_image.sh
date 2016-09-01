#!/usr/bin/env bash

set -ex
docker build --build-arg BUILD_NUMBER=1 web/ -f web/Dockerfile -t lifeizhou/oche_web:1
docker build app/ -f app/Dockerfile -t lifeizhou/oche_app:1