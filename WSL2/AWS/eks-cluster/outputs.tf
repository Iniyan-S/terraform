output "eks-cluster-name" {
  value = aws_eks_cluster.my-eks-cluster.id
  description = "EKS Cluster Name"
}

output "eks-cluster-endpoint" {
  value = aws_eks_cluster.my-eks-cluster.endpoint
  description = "EKS Cluster Endpoint"
}

# To extract the value from "eks-cluster-ca" output run
# Install jq package
# terraform output -json eks-cluster-ca | jq .[0].data

output "eks-cluster-ca" {
  value = aws_eks_cluster.my-eks-cluster.certificate_authority
  description = "EKS Cluster certificate-authority-data"
}

output "cluster-region" {
  value = var.region
  description = "AWS Region"
}