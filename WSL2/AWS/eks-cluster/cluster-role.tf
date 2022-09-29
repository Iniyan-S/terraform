# Create Cluster Role 

resource "aws_iam_role" "my-eks-cluster-role" {
  name = "my-eks-cluster-role"

  assume_role_policy = <<EOF
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
EOF

}

# Attach AWS Managed Poicy "AmazonEKSClusterPolicy"

resource "aws_iam_role_policy_attachment" "my-eks-cluster-role-policy-attach" {
  role = aws_iam_role.my-eks-cluster-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

