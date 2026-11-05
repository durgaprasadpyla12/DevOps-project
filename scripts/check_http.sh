#!/usr/bin/env bash
# Usage: ./check_http.sh <url> [expected_status] [timeout_seconds]

URL="${1:?Usage: $0 <url> [expected_status] [timeout_seconds]}"
EXPECTED="${2:-200}"
TIMEOUT="${3:-5}"

STATUS=$(curl -s -o /dev/null -w "%{http_code}" --max-time "$TIMEOUT" "$URL")

if [ "$STATUS" = "$EXPECTED" ]; then
  echo "OK: $URL returned $STATUS"
  exit 0
else
  echo "CRITICAL: $URL returned $STATUS (expected $EXPECTED)"
  exit 2
fi
