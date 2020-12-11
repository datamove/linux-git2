#!/bin/bash
nam=$1
name='"'$nam'"'
curl -s -X GET "https://api.github.com/repos/datamove/linux-git2/issues?state=all&page=1&per_page=100" > tmp.json
curl -s -X GET "https://api.github.com/repos/datamove/linux-git2/issues?state=all&page=2&per_page=100" >> tmp.json
var=$(cat tmp.json | jq '.[] | .user' | jq 'select(.login=='$name') | .login' | wc -l) 
echo PULLS $var
min_date=$(cat tmp.json | jq '.[]' | jq 'select(.user.login=='$name')' | jq '.created_at' | sort | head -1)
num=$(cat tmp.json | jq '.[]' | jq 'select(.user.login=='$name' and .created_at=='$min_date') | .number')
echo EARLIEST $num
echo MERGED 0
