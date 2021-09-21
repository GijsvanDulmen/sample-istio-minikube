#!/bin/bash
npm install

OS="$(uname)"
if [ "x${OS}" = "xDarwin" ] ; then
  open http://${MINIKUBE_IP}:30567
  open http://${MINIKUBE_IP}:30789
  open http://${MINIKUBE_IP}:30123/kiali/console/graph/namespaces/?edges=requestsPerSecond%2CresponseTime%2Crt95%2Cthroughput%2CthroughputRequest%2CtrafficDistribution%2CtrafficRate&graphType=versionedApp&namespaces=default%2Cistio-system&unusedNodes=false&operationNodes=true&injectServiceNodes=true&duration=60&refresh=15000&layout=dagre&traffic=grpc%2CgrpcRequest%2Chttp%2ChttpRequest%2Ctcp%2CtcpSent&idleNodes=false&idleEdges=false
else
  echo "Please open the following websites manually in your browser:"
  echo http://${MINIKUBE_IP}:30567
  echo http://${MINIKUBE_IP}:30789
  echo http://${MINIKUBE_IP}:30123/kiali/console/graph/namespaces/?edges=requestsPerSecond%2CresponseTime%2Crt95%2Cthroughput%2CthroughputRequest%2CtrafficDistribution%2CtrafficRate&graphType=versionedApp&namespaces=default%2Cistio-system&unusedNodes=false&operationNodes=true&injectServiceNodes=true&duration=60&refresh=15000&layout=dagre&traffic=grpc%2CgrpcRequest%2Chttp%2ChttpRequest%2Ctcp%2CtcpSent&idleNodes=false&idleEdges=false
  sleep 120
fi
node index.js ${MINIKUBE_IP}