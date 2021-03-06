#!/bin/bash
set -e

COMMANDS="debug help logtail show stop adduser fg kill quit run wait console foreground logreopen reload shell status"
START="start restart"

python /docker-initialize.py

if [[ $START == *"$1"* ]]; then
  _stop() {
    bin/instance stop
    kill -TERM $child 2>/dev/null
  }

  trap _stop SIGTERM SIGINT
  bin/instance start
  bin/instance logtail &

  child=$!
  wait "$child"
else
  if [[ $COMMANDS == *"$1"* ]]; then
    exec bin/instance "$@"
  fi
  exec "$@"
fi
