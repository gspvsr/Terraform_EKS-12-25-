data "aws_eks_cluster" "eks-cluster" {
  name = "ap-medium"
}

data "aws_eks_cluster_auth" "eks-cluster-auth" {
  name = "ap-medium"
}

data "aws_vpc" "vpc" {
  tags = {
    Name = "ap-medium"
  }
}