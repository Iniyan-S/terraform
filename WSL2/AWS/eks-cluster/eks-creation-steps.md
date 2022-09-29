## Ref:

- https://docs.aws.amazon.com/eks/latest/userguide/getting-started-console.html
- https://docs.aws.amazon.com/eks/latest/userguide/create-cluster.html


## Create EKS Cluster

1. Create an Amazon VPC with public and private subnets that meets Amazon EKS requirements
    - Create VPC - my-eks, range 192.168.0.0/16
    - Create subnet - my-eks-sn-01 (ap-south-1a) (192.168.1.0/24) & my-eks-sn-02 (ap-south-1b) (192.168.2.0/24) & enable auto-assign Public IP
      - Subnets must have tag "kubernetes.io/cluster/CLUSTER_NAME" = "shared" to associate with EKS Node Groups later.
    - Associate two subnets to defautl route table
    - Create IGW, under VPC my-eks
    - Edit default route table, 0.0.0.0/0 -> IGW

2. Create a cluster IAM role and attach the required Amazon EKS IAM managed policy to it.

    - Create Role : my-eks-cluster-role

    - Trusted entity type : "Service": "eks.amazonaws.com"
```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}

```
 - Attach AWS Managed - EKS Cluster Policy "AmazonEKSClusterPolicy" to role "my-eks-cluster-role" (Policy ARN: arn:aws:iam::aws:policy/AmazonEKSClusterPolicy)
```
["AmazonEKSClusterPolicy"]
```
3. Create Cluter
    - Name: my-eks-cluster
    - give kubernetes version (1.22 - default)
    - add cluster service role (my-eks-cluster-role)
    - select networking (choose VPC - my-eks-vpc, subnets (ap-south-1a)/(ap-south-1b), security group, optional, give service ip range)
    - Cluster endpoint access - public
    - Networking add-ons 
        - Amazon VPC CNI (enable pod networking within your cluster) - v1.10.1-eksbuild.1
        - CoreDNS (v1.8.7-eksbuild.1)
        - kube-proxy (v1.22.6-eksbuild.1)


## Configure to communicate with cluster

1. Have 'kubectl' installed.
2. Create or update a kubeconfig file for the cluster.

```
aws eks update-kubeconfig --region region-code --name my-cluster
```
3. Test configuration

 ```
 kubectl get svc

 NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.100.0.1   <none>        443/TCP   66m
 ```

## Create Nodes

1. Create a node IAM role and attach the required Amazon EKS IAM managed policies to it.
    - Create Role : my-eks-node-role
    - Trusted entity type : "Service": "ec2.amazonaws.com"
 ```
 {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```
- Attach below AWS managed policies to the node IAM role (my-eks-node-role)

```
[ AmazonEKSWorkerNodePolicy , AmazonEC2ContainerRegistryReadOnly , AmazonEKS_CNI_Policy ]
```

2. Create Node Group
    - Name: my-eks-ng-dev
    - attach node IAM role: my-eks-node-role
    - Optional : node group can have K8S taints (nodes created under this NG will have mentioned taint)
    - Node Group Compute Configuration:
        - AMI Name: Amazon Linux 2 (AL2_x86_64) EKS-optimized Amazon Machine Image for nodes.
        - Capacity type: On-Demand / Spot
        - Instance types: t3.medium (2 vCPUs, 4 GiB Memory)
        - Disk size: 20 GB
    - Node Group scaling configuration:
        - Desired State / Minimum State / Maximum State -2
    - Node group update configuration - 1 (Set the maximum number or percentage of unavailable nodes to be tolerated during the node group version update)
    - Node group network configuration:
        - Subnets: Created in the EKS VPC 
        - enable SSH access to nodes (provide ssh key pair, allow ssh remote access from security group (have it creted already with allowed source ips))