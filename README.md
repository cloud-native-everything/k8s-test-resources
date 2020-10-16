# k8s-test-resources
Some resources you can use to test your k8s cluster

## Hello world node image with hostname

You can use it to test a K8s service (i.e. ClusetIP) and check how load is balance between different pods through an Ingress.
It will give you and output like this:

```
[root@minion02 ~]# cat << 'EOF' >> 0_curl_test.sh 
while true
do
 curl http://10.254.222.1:8080
 sleep 1
done
EOF
[root@minion02 ~]# chmod 755 0_curl_test.sh
[root@minion02 ~]# ./0_curl_test.sh 
Hello World version ONE! Host/Podhello-node-3439300230-bg6ew
Hello World version ONE! Host/Podhello-node-3439300230-bg6ew
Hello World version ONE! Host/Podhello-node-3439300230-w4qeg
Hello World version ONE! Host/Podhello-node-3439300230-bg6ew
Hello World version ONE! Host/Podhello-node-3439300230-or7r0
```
Just get the Dockerfile and build it.
I've created an image at pinrojas/hello-node:v1 y you want it to use it now and save the time for building your own one.

In fact, you can use also heelo-node-deploy.yaml to create a deployment of 4 replicas to test you Kubernetes

```
# Create deployment 4 replicas
kubectl create -f hello-node-deploy.yaml

# Create NodepOrt service with this deployment
kubectl expose deployment hello-node-deploy --type=NodePort

# Check service
kubectl describe services hellp-node-nport

# You should get an output ike this
Name:                     hellp-node-nport
Namespace:                default
Labels:                   <none>
Annotations:              <none>
Selector:                 run=hello-node-svc
Type:                     NodePort
IP:                       10.99.66.126
Port:                     <unset>  8080/TCP
TargetPort:               8080/TCP
NodePort:                 <unset>  30083/TCP
Endpoints:                10.140.135.129:8080,10.140.135.130:8080,10.140.58.192:8080 + 1 more...
Session Affinity:         None
External Traffic Policy:  Cluster
Events:                   <none>

# test your exposed deployment
curl http://10.10.10.102:30083

#You should get an output like this
Hello World version ONE! Host/Pod: hello-node-deploy-8568b8dfb6-njvgc
[root@k8s-node01 ~]# curl http://10.10.10.102:30083
Hello World version ONE! Host/Pod: hello-node-deploy-8568b8dfb6-kltsv
[root@k8s-node01 ~]# curl http://10.10.10.102:30083
Hello World version ONE! Host/Pod: hello-node-deploy-8568b8dfb6-kltsv
[root@k8s-node01 ~]# curl http://10.10.10.102:30083
Hello World version ONE! Host/Pod: hello-node-deploy-8568b8dfb6-67f8x
[root@k8s-node01 ~]# curl http://10.10.10.102:30083
Hello World version ONE! Host/Pod: hello-node-deploy-8568b8dfb6-nxvtv
[root@k8s-node01 ~]# curl http://10.10.10.102:30083
Hello World version ONE! Host/Pod: hello-node-deploy-8568b8dfb6-nxvtv

```
See ya!
