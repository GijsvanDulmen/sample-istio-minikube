# A sample of Istio with MiniKube

## Steps to get this to work
- Make sure you have NodeJS and NPM installed
- https://minikube.sigs.k8s.io/docs/start/

## Make sure minikube is on your $PATH
Example:
```
export PATH=$PATH:/usr/local/Cellar/minikube/1.16.0/bin/
```
## Install cluster
After the install has finished, sample applications will be deployed and a script will be called to generate trafic. Normally, your browser will show three new tabs, containg Jaeger, Grafana and Kiali. You can stop the cluster by pressing CMD-C or CTRL-C

```
cd cluster
./install.sh
```

## Startup cluster and run tests!
If you've already installed the cluster, you can simply fire it up again by running the following script. Note that this script wil also start the trafic generator. Again, if your finished, just hit CMD-C or CTRL-C.

NOTE: you'll see some connection problems in the beginning, which is completely normal.
```
cd cluster
./up.sh
cd ..
```
