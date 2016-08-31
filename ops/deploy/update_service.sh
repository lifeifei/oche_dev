#!/usr/bin/env bash
set -ex

bundle exec rake service:create_task
bundle exec rake service:update_service