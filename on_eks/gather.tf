data "aws_eks_cluster" "eks-cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "eks-cluster-auth" {
  name = var.cluster_name
}

data "aws_vpc" "vpc" {
  id = "vpc-09cbf860b810f0cb8" # <-- replace with your real VPC ID
}

data "tls_certificate" "eks" {
  url = data.aws_eks_cluster.eks-cluster.identity[0].oidc[0].issuer
}

