data "aws_eks_cluster" "eks-cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "eks-cluster-auth" {
  name = var.cluster_name
}

data "aws_vpc" "vpc" {
  tags = {
    Name = var.cluster_name
  }
}

data "tls_certificate" "eks" {
  url = data.aws_eks_cluster.eks-cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  url = data.aws_eks_cluster.eks-cluster.identity[0].oidc[0].issuer

  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = [
    data.tls_certificate.eks.certificates[0].sha1_fingerprint
  ]
}
