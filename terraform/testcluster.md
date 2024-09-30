Test the cluster by creating a workload:

1. Deploy and expose an nginx pod

kubectl create deployment nginx --image nginx:alpine
kubectl expose deploy nginx --type=NodePort --port 80

PORT_NUMBER=$(kubectl get service -l app=nginx -o jsonpath="{.items[0].spec.ports[0].nodePort}")
echo -e "\n\nService exposed on NodePort $PORT_NUMBER"

2. Hit the new service 

curl http://node01:$PORT_NUMBER
curl http://node02:$PORT_NUMBER

3. Viewing service with the browser:

http://<NODE_IP>:<PORT_NUMBER>