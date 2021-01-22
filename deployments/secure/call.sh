#!/bin/bash
source ../../cluster/env.sh
SECURE_URL="http://${MINIKUBE_IP}:30000/secure"

echo "=== Token ==="
echo -n $TOKEN | cut -d '.' -f2 - | base64 -D | jq .

echo ""
echo "=== Call secure url ==="
if [ -x "$(command -v http)" ]; then
    http -v GET ${SECURE_URL} Authorization:"Bearer $TOKEN"
else
    curl ${SECURE_URL} -v -o /dev/null -H "Authorization: Bearer $TOKEN"
fi