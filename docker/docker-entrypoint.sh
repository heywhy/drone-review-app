#!/bin/bash
# docker entrypoint script.

bin="/app/bin/review_app"
# migrate database
eval "$bin eval \"ReviewApp.Release.migrate\""
# start the elixir application
exec "$bin" "start"
