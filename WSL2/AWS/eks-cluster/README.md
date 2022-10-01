## Ref:

- https://docs.aws.amazon.com/eks/latest/userguide/getting-started-console.html
- https://docs.aws.amazon.com/eks/latest/userguide/create-cluster.html
- https://docs.aws.amazon.com/eks/latest/userguide/autoscaling.html
- https://www.youtube.com/watch?v=lMb6wzy0PPA&t=1s

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
(OR)
aws eks update-kubeconfig --name $(terraform output -raw eks-cluster-name) --region $(terraform output -raw cluster-region)
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
  - Create a custom policy "AmazonEKSClusterAutoscalerPolicy" for auto scaling ability of node role.
```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor1",
      "Effect": "Allow",
      "Action": [
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeAutoScalingGroups",
          "ec2:DescribeLaunchTemplateVersions",
          "autoscaling:DescribeTags",
          "autoscaling:DescribeLaunchConfigurations"
      ],
      "Resource": "*"
    }
  ]
}
```
  - Attach below AWS managed policies to the node IAM role (my-eks-node-role) and the custom policy created above.
    - Adding custom policy "AmazonEKSClusterAutoscalerPolicy" to node role, is deviated from the current recommendation to assign it to Web identity (OpenID Connect provider URL)
      as per recent AWS documentation, https://docs.aws.amazon.com/eks/latest/userguide/autoscaling.html fromt the previous one.

```
[ AmazonEKSWorkerNodePolicy , AmazonEC2ContainerRegistryReadOnly , AmazonEKS_CNI_Policy, AmazonEKSClusterAutoscalerPolicy ]
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

## Deploy Cluster Autoscaler

Ref: https://docs.aws.amazon.com/eks/latest/userguide/autoscaling.html

1. Download Cluster Autoscaler YAML file.
```
curl -o cluster-autoscaler-autodiscover.yaml https://raw.githubusercontent.com/kubernetes/autoscaler/master/cluster-autoscaler/cloudprovider/aws/examples/cluster-autoscaler-autodiscover.yaml
```
2. Update the downnloaded yaml file as below,

 - Add Annotations, under spec.template.metadata.annootations "cluster-autoscaler.kubernetes.io/safe-to-evict: 'false'"
  ```
  spec:
  replicas: 1
  selector:
    matchLabels:
      app: cluster-autoscaler
  template:
    metadata:
      labels:
        app: cluster-autoscaler
      annotations:
        prometheus.io/scrape: 'true'
        prometheus.io/port: '8085'
        cluster-autoscaler.kubernetes.io/safe-to-evict: 'false'
```
 - Update the cluster-autoscaler container command to add the following options and **CLUSTER_NAME**
    - --balance-similar-node-groups
    - --skip-nodes-with-system-pods=false
    - --node-group-auto-discovery=asg:tag=k8s.io/cluster-autoscaler/enabled,k8s.io/cluster-autoscaler/**my-eks-cluster**

 - Open the Cluster Autoscaler [release] page from GitHub in a web browser and find the latest Cluster Autoscaler version that matches the Kubernetes **major** and **minor** version of your cluster. For example, if the Kubernetes version of your cluster is 1.23, find the latest Cluster Autoscaler release that begins with 1.23. Record the semantic version number (1.23.n) for that release to use in the next step.

 - Set the Cluster Autoscaler image tag to the version that you obtained in the previous step.
   - image: k8s.gcr.io/autoscaling/cluster-autoscaler:**v1.21.3**

```
 containers:
        - image: k8s.gcr.io/autoscaling/cluster-autoscaler:v1.21.3
          name: cluster-autoscaler
          resources:
            limits:
              cpu: 100m
              memory: 600Mi
            requests:
              cpu: 100m
              memory: 600Mi
          command:
            - ./cluster-autoscaler
            - --v=4
            - --stderrthreshold=info
            - --cloud-provider=aws
            - --skip-nodes-with-local-storage=false
            - --expander=least-waste
            - --node-group-auto-discovery=asg:tag=k8s.io/cluster-autoscaler/enabled,k8s.io/cluster-autoscaler/my-eks-cluster
            - --balance-similar-node-groups
            - --skip-nodes-with-system-pods=false
```

[release]: <https://github.com/kubernetes/autoscaler/releases>

- Apply the YAML file to your cluster.
```
kubectl apply -f cluster-autoscaler-autodiscover.yaml
```