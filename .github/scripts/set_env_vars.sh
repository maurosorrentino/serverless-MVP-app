#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT="$1"
CONFIG_FILE=".github/workflows/env_vars/$ENVIRONMENT/env_vars.json"

echo "Loading environment variables from $CONFIG_FILE"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "Config file not found: $CONFIG_FILE" >&2
  exit 1
fi

jq -r 'to_entries[] | "\(.key)=\(.value)"' "$CONFIG_FILE" >> "$GITHUB_ENV"
