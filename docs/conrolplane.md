1. Set up the kubeconfig so it can be used by the user you are logged in as:
```bash
{
    mkdir ~/.kube
    sudo cp /etc/kubernetes/admin.conf ~/.kube/config
    sudo chown $(id -u):$(id -g) ~/.kube/config
    chmod 600 ~/.kube/config
}
```
2. Verify:
```bash
kubectl get pods -n kube-system
```
