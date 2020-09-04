# k8s-test-resources
Some resources you can use to test your k8s cluster

## Hello world node image with hostname

You can use it to test a K8s service (i.e. ClusetIP) and check how load is balance between different pods.
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
