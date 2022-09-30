# Create Node Role

resource "aws_iam_role" "my-eks-node-role" {
    name = "my-eks-node-role"

    assume_role_policy = <<EOF
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
EOF 
}

# Create IAM for Auto Scaler

resource "aws_iam_policy" "AmazonEKSClusterAutoscalerPolicy" {
  name = "AmazonEKSClusterAutoscalerPolicy"
  description = "Amazon EKs - Cluster autoscaler policy"

  policy = <<EOF
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
EOF
}

# Attach AWS Managed Policied [ AmazonEKSWorkerNodePolicy , AmazonEC2ContainerRegistryReadOnly , AmazonEKS_CNI_Policy ] and Custom Policy [AmazonEKSClusterAutoscalerPolicy]

resource "aws_iam_role_policy_attachment" "my-eks-node-worker-policy-attach" {
  role = aws_iam_role.my-eks-node-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "my-eks-node-ec2-continer-registry-ro-policy-attach" {
  role = aws_iam_role.my-eks-node-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "my-eks-node-eks-cni-policy-attach" {
  role = aws_iam_role.my-eks-node-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "my-eks-node-eks-autoscale-policy-attach" {
  role = aws_iam_role.my-eks-node-role.name
  policy_arn = aws_iam_policy.AmazonEKSClusterAutoscalerPolicy.arn
}