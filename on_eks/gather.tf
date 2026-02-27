data "aws_eks_cluster" "eks-cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "eks-cluster-auth" {
  name = var.cluster_name
}

data "aws_vpc" "vpc" {
  id = "vpc-09fa3b905d60bc943" # <-- replace with your real VPC ID
}

data "tls_certificate" "eks" {
  url = data.aws_eks_cluster.eks-cluster.identity[0].oidc[0].issuer
}

data "aws_iam_openid_connect_provider" "eks" {
  arn = "arn:aws:iam::847713921303:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/B5547E6F1A86BFF52A6EBBD72171E116"
}

