#!/usr/bin/env bash
# base on https://gist.github.com/dhh/c5051aae633ff91bc4ce30528e4f0b60

# Abort on any error
set -e

# Start the benchmark timer
SECONDS=0

# Repository introspection
SHA=$(git rev-parse HEAD)

# Progress reporting
GREEN=32
RED=31
BLUE=34
announce() { echo -e "\033[0;$2m$1\033[0m"; }
run() {
  local SPLIT=$SECONDS
  announce "\nRun $1" $BLUE
  eval "$1"
  local INTERVAL=$((SECONDS - SPLIT))
  announce "Completed $1 in $INTERVAL seconds" $GREEN
}

# Required steps for sign off
run "bundle exec rubocop"
run "bundle exec bundle-audit check --update"
run "bundle exec brakeman -q --no-summary"
run "./bin/rails test"

announce "Signed off on $SHA in $SECONDS seconds" $GREEN
