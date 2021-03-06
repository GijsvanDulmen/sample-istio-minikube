#!/bin/bash
kubectl -n default apply -f ./gateway.yml
kubectl -n default apply -f ./virtualservice.yml

cd simple-deployment
./install.sh

cd ..
cd rocksolid
./install.sh

cd ..
kubectl -n default apply -f ./needhelp
kubectl -n default apply -f ./security
kubectl -n default apply -f ./secure
kubectl -n istio-system apply -f ./headers

while ! kubectl wait --for=condition=available --timeout=600s deployment/echo-server-v1 -n default; do sleep 1; done

# Startup traffic generation
cd ../traffic-generator
./run.sh