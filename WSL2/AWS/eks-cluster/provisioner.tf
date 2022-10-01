resource "null_resource" "kc-apply" {
  provisioner "local-exec" {
    command = "kubectl apply -f cluster-autoscaler-autodiscover.yaml"
  }
  depends_on = [
    aws_eks_node_group.my-eks-ng-dev,
    null_resource.update-kubeconfig
  ]
}

resource "null_resource" "update-kubeconfig" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name $(terraform output -raw eks-cluster-name) --region $(terraform output -raw cluster-region)"
  }

  depends_on = [
    aws_eks_cluster.my-eks-cluster,
    aws_eks_node_group.my-eks-ng-dev
  ]
}