#!/bin/bash
npm install

export MINIKUBE_IP=`minikube ip`
open http://${MINIKUBE_IP}:30567
open http://${MINIKUBE_IP}:30123/kiali/console/graph/namespaces/\?edges\=requestsPerSecond\&graphType\=versionedApp\&namespaces\=default%2Cistio-system\&unusedNodes\=false\&operationNodes\=false\&injectServiceNodes\=true\&duration\=60\&refresh\=15000\&layout\=dagre

node index.js ${MINIKUBE_IP}