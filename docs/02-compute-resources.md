# Provisioning Compute Resources

We will provision the following infrastructure. The infrastructure will be created by Terraform.
![Infra](../images/kubeadm-aws-architecture.png)


As can be seen in this diagram, we will create three EC2 instances to form the cluster and a further one `student-node` from which to perform the configuration. We build the infrastructure using Terraform from AWS CloudShell (so you don't have to install Terraform on your workstation), then log into `student-node` which can access the cluster nodes using SSH. Note that SSH connections are only possible in the direction of the arrows. It is not possible to SSH from e.g. `controlplane` directly to `node01`. You must `exit` to `student-node` first. `student-node` assumes the role of a [bastion host](https://en.wikipedia.org/wiki/Bastion_host).

We will also set up direct connection from your workstation to the node ports of the workers so that you can browse any NodePort services you create (see security below).

Some basic security will be configured:

* Only the `student-node` can SSH to the cluster nodes.
* Ports required by Kubernetes itself (inc. etcd) and Weave CNI will be configured in security groups on the cluster nodes.

Security issues that would make this unsuitable for a genuine production cluster:

* The kube nodes should be on private subnets (no direct access from the Internet) and placed behind a NAT gateway to allow them to download packages, or with a more extreme security posture, completely [airgapped](https://en.wikipedia.org/wiki/Air_gap_(networking)).
* Access to API server and etcd would be more tightly controlled.
* Use of default VPC is not recommended.
* The node ports will be open to the world - i.e. anyone can connect to them.
* A cloud load balancer coupled with an ingress controller would be provisioned to provide ingress to the cluster. It is _definitely_ not recommended to expose the worker nodes' node ports to the Internet as we are doing here!!!

Other things that will be configured by the Terraform code
* Host names set on the nodes: `controlplane`, `node01`, `node02`
* Content of `/etc/hosts` set up on all nodes for easy use of `ssh` command from `student-node`.
* Generation and distribution of a key pair for logging into instances via SSH.

Let's go ahead and get the infrastructure built!

We will run this entire lab in AWS CloudShell which is a Linux terminal you run inside the AWS console and has most of what we need preconfigured, such as git and the AWS credentials needed by Terraform. [Click here](https://us-east-1.console.aws.amazon.com/cloudshell/home?region=us-east-1) to open CloudShell - note that this link will not work until you have signed into the AWS console.


## Install Terraform

From the CloudShell command prompt...

```bash
curl -O https://releases.hashicorp.com/terraform/1.6.2/terraform_1.6.2_linux_amd64.zip
unzip terraform_1.6.2_linux_amd64.zip
mkdir -p ~/bin
mv terraform ~/bin/
terraform version
```

## Clone this repo

```bash
git clone https://github.com/shah-jalal/kubeadm-cluster.git
```

Now change into the `kubeadm-cluster/terraform` directory

```bash
cd kubeadm-cluster/terraform/
```

## Provision the infrastructure

1. Run the terraform

    ```bash
    terraform init
    terraform plan
    terraform apply
    ```

    This should take about half a minute. If this all runs correctly, you will see something like the following at the end of all the output. IP addresses _will be different_ for you

    ```
    Apply complete! Resources: 22 added, 0 changed, 0 destroyed.

    Outputs:

    address_node01 = "44.220.138.27"
    address_node02 = "54.167.161.210"
    address_student_node = "34.205.252.168"
    connect_student_node = <<EOT
    Use the following command to log into student-node

      ssh ubuntu@34.205.252.168

    You should wait till all instances are fully ready in the EC2 console.
    The Status Check colunm should contain "2/2 checks passed"


    EOT
    ```

    Copy all these outputs to a notepad for later use.

1. Wait for all instances to be ready (Instance state - `running`, Status check - `2/2 checks passed`). This will take 2-3 minutes. See [EC2 console](https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#Instances:instanceState=running).

1. Log into `student-node`

    Copy the `ssh` command from the terraform output `connect_student_node`, e.g.

    ```
    ssh ubuntu@100.26.200.3
    ```

    Note that the IP address _will be different_ for you.

    You should arrive at a prompt that looks like this

    ```
    ubuntu in 🌐 student-node in ~
    ❯
    ```

## Prepare the student node

We will install kubectl here so that we can run commands against the cluster when it is built

1. Install latest version of kubectl and place in the user programs directory
    ```bash
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin
    ```

1. Check

    ```bash
    kubectl version
    ```

    It should amongst other things tell you

    > The connection to the server localhost:8080 was refused - did you specify the right host or port?

    which is fine, since we haven't installed kubernetes yet.

## Deleting the cluster

If you are using your own account, this is *crucial* as you will be billed for the resources created until you delete them - unless of course you want to keep it around and pay. Recall that this is *not* a production hardened installation and could pose a security risk to your account if you leave it lying around.

To delete

1. Return to the CloudShell terminal
1. In the same directory where you ran `terraform apply`, run

    ```
    terraform destroy -auto-approve
    ```

## Notes on the terraform code

One point of note is that for the `node` instances, we create network interfaces for them as separate resources, then attach these ENIs to the instances when they are built. The reason for this is so that the IP addresses of the instances can be known in advance, such that during instance creation `/etc/hosts` may be created by the user_data script.


Next: [Connectivity](./03-connectivity.md)<br/>
Prev: [Prerequisites](./01-prerequisites.md)
