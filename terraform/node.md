Join Worker nodes:
If you did not note down the join command on the cotrolplane node after running kubeadm, you can recover it by running the following on controlplane:

kubeadm token create --print-join-command

1. On each of node01 and node02 do the following:

Become root (if you are not already)

sudo -i

2. Join the node

Paste the kubeadm join command output 

3. Verify:
On conrolplane run the following.

kubectl get nodes