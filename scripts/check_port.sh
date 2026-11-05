#!/usr/bin/env bash
# Usage: ./check_port.sh <host> <port> [timeout_seconds]
# Checks whether a TCP port is reachable (e.g. Apache 80/443, JBoss 8080, WAS 9060, MQ 1414).

HOST="${1:?Usage: $0 <host> <port> [timeout_seconds]}"
PORT="${2:?Usage: $0 <host> <port> [timeout_seconds]}"
TIMEOUT="${3:-5}"

if nc -z -w "$TIMEOUT" "$HOST" "$PORT" >/dev/null 2>&1; then
  echo "OK: $HOST:$PORT is reachable"
  exit 0
else
  echo "CRITICAL: $HOST:$PORT is not reachable"
  exit 2
fi
