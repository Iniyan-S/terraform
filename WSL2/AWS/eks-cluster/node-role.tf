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

# Attach AWS Managed Policied [ AmazonEKSWorkerNodePolicy , AmazonEC2ContainerRegistryReadOnly , AmazonEKS_CNI_Policy ]

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