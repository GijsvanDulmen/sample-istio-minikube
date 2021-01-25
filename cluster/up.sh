#!/bin/bash

set -e exit

minikube -p sample-istio-minikube start --memory=8192 --cpus=4 --vm=true --driver=hyperkit
# Open up something
source ./env.sh

while ! kubectl wait --for=condition=available --timeout=600s deployment/echo-server-v1 -n default; do sleep 1; done

kubectl get pods --all-namespaces

cd ../traphic-generator
./run.sh