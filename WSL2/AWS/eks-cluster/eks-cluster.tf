# Create Cluster

resource "aws_eks_cluster" "my-eks-cluster" {
    name = "my-eks-cluster"
    role_arn = aws_iam_role.my-eks-cluster-role.arn
    # version = "1.21"
    vpc_config {
      subnet_ids = [ aws_subnet.my-eks-sn-01.id, aws_subnet.my-eks-sn-02.id ]
      endpoint_public_access = true
      public_access_cidrs = [ "115.99.14.220/32" ] # Indicates which CIDR blocks can access the Amazon EKS public API server endpoint when enabled
    #   security_group_ids = aws_vpc.my-eks-vpc.default_security_group_id
    }

    kubernetes_network_config {
      ip_family = "ipv4"
      service_ipv4_cidr = "10.0.0.0/16"
    }
  
    depends_on = [aws_iam_role_policy_attachment.my-eks-cluster-role-policy-attach]

    tags = {
      Name = "my-eks-cluster"
    }
  
}


output "endpoint" {
    value = aws_eks_cluster.my-eks-cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.my-eks-cluster.certificate_authority[0].data
}