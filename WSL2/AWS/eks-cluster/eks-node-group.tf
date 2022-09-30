# Create Node Groups

resource "aws_eks_node_group" "my-eks-ng-dev" {
  node_group_name = "my-eks-ng-dev"
  cluster_name = aws_eks_cluster.my-eks-cluster.name
  node_role_arn = aws_iam_role.my-eks-node-role.arn
  subnet_ids = [ aws_subnet.my-eks-sn-01.id, aws_subnet.my-eks-sn-02.id  ]
  ami_type = "AL2_x86_64"
  capacity_type = "ON_DEMAND"
  disk_size = 8
  instance_types = ["t3.medium"]

  remote_access {
    ec2_ssh_key = "in-user"
    source_security_group_ids = [ aws_security_group.my-eks-ng-sg.id ]
  }
  taint {
    key = "env"
    value = "dev"
    effect = "NO_SCHEDULE"
  }

  scaling_config {
    desired_size = 2
    max_size = 4
    min_size = 1
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.my-eks-node-worker-policy-attach,
    aws_iam_role_policy_attachment.my-eks-node-ec2-continer-registry-ro-policy-attach,
    aws_iam_role_policy_attachment.my-eks-node-eks-cni-policy-attach,
    aws_iam_role_policy_attachment.my-eks-node-eks-autoscale-policy-attach,
    aws_security_group.my-eks-ng-sg
 ]
}

