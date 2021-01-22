#!/bin/bash

set -e exit

minikube -p sample-istio-minikube start --memory=8192 --cpus=4 --vm=true --driver=hyperkit


##### ISTIO INSTALLATION THROUGH OPERATOR #####

## Download istio if not already downloaded
export ISTIO_VERSION=1.8.2
if [ ! -d "./istio-${ISTIO_VERSION}" ] 
then
    curl -L https://istio.io/downloadIstio | ISTIO_VERSION=${ISTIO_VERSION} sh -
fi
export PATH=$PWD/istio-${ISTIO_VERSION}/bin:$PATH

kubectl create namespace istio-system
kubectl apply -f kiali-secret.yml

## Installing Istio Operator
istioctl operator init
kubectl -n istio-operator wait --for=condition=available --timeout=600s deployment/istio-operator

## Installing Istio Controlplane"
kubectl apply -f istio.yml
sleep 20 # needed to let the operator pick up the configuration
kubectl -n istio-system wait --for=condition=available --timeout=600s deployment/istiod

##### PROMETHEUS #####
echo "Installing prometheus"
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.8/samples/addons/prometheus.yaml || :

##### KIALI 1.26 #####

# do this twice because of some odd error of missing CRD's
# see: https://github.com/istio/istio/issues/27417
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.8/samples/addons/kiali.yaml || :
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.8/samples/addons/kiali.yaml || :

# Open Kiali on NodePort
kubectl -n istio-system patch svc kiali --patch '{"spec": { "type": "NodePort", "ports": [ { "name": "http", "nodePort": 30123, "port": 20001, "protocol": "TCP", "targetPort": 20001 }, { "name": "http-metrics", "nodePort": 30333, "port": 9090, "protocol": "TCP", "targetPort": 9090 } ] } }'

#### JAEGER #####
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.8/samples/addons/jaeger.yaml
kubectl -n istio-system patch svc tracing --patch '{"spec": { "type": "NodePort", "ports": [ { "name": "http-query", "nodePort": 30567, "port": 80, "protocol": "TCP", "targetPort": 16686 } ] } }'

##### GRAFANA #####
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.8/samples/addons/grafana.yaml
kubectl -n istio-system patch svc grafana --patch '{"spec": { "type": "NodePort", "ports": [ { "name": "service", "nodePort": 30789, "port": 3000, "protocol": "TCP", "targetPort": 3000 } ] } }'

##### FLAGGER #####
kubectl apply -k github.com/weaveworks/flagger//kustomize/istio

# wait for everything to be available
kubectl -n istio-system wait --for=condition=available --timeout=600s deployment/prometheus
kubectl -n istio-system wait --for=condition=available --timeout=600s deployment/kiali
kubectl -n istio-system wait --for=condition=available --timeout=600s deployment/flagger

# enable injection on default
kubectl label namespace default istio-injection=enabled

sleep 2

# install flagger stuff
kubectl apply -f ../flagger/deployment.yml
kubectl apply -f ../flagger/canary.yml

# Open up something
cd ../deployments
./install.sh

kubectl get pods --all-namespaces

source env.sh