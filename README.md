# Installing Kubernetes the kubeadm way on AWS EC2

Updated March 2024

This guide shows how to install a 3 node kubeadm cluster on AWS EC2 instances. Please ensure you have selected region `us-east-1` (N. Virginia) from the region selection at the top right of the AWS console. We will use the following EC2 instance configuration.

* Instance type: `t3.medium`
* Operating System: Ubuntu 22.04 (at time of writing)
* Storage: `gp2`, 8GB

Note that this is a demo to simply getting a cluster running and is a learning purposes only! It should not be used as a basis for building a production cluster.


[Get Started](./docs/01-prerequisites.md)

