resource "aws_eks_cluster" "eks" {
  name  = var.cluster_name
  count = var.is-eks-cluster-enabled == true ? 1 : 0

  role_arn = aws_iam_role.eks-cluster-role[count.index].arn
  version  = var.cluster-version

  vpc_config {
    subnet_ids              = [aws_subnet.private-subnet[0].id, aws_subnet.private-subnet[1].id]
    endpoint_private_access = var.endpoint-private-access
    endpoint_public_access  = var.endpoint-public-access
    security_group_ids      = [aws_security_group.eks-cluster-sg.id]
  }

  access_config {
    authentication_mode                         = "CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  tags = {
    Name = var.cluster_name
    Env  = var.env
  }

}

#OIDC provider
resource "aws_iam_openid_connect_provider" "eks_oidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_certificate.certificates[0].sha1_fingerprint]
  url             = data.tls_certificate.eks_certificate.url
}


# Addons for EKS Cluster
resource "aws_eks_addon" "eks-addon" {
  for_each      = { for idx, addon in var.addons : idx => addon }
  cluster_name  = aws_eks_cluster.eks[0].name
  addon_name    = each.value.name
  addon_version = each.value.version

  depends_on = [
    aws_eks_node_group.ondemand-node,
    aws_eks_node_group.spot-node
  ]
}

#nodeGroups onDemand
resource "aws_eks_node_group" "ondemand-node" {
  cluster_name    = aws_eks_cluster.eks[0].name
  node_group_name = "${var.cluster_name}-on-demand-nodes"

  node_role_arn = aws_iam_role.eks-nodegroup-role[0].arn

  scaling_config {
    desired_size = var.desired_capacity_on_demand
    min_size     = var.min_capacity_on_demand
    max_size     = var.max_capacity_on_demand
  }

  subnet_ids = [aws_subnet.private-subnet[0].id, aws_subnet.private-subnet[1].id]

  instance_types = var.ondemand_instance_types
  capacity_type  = "ON_DEMAND"
  labels = {
    type = "ondemand"
  }

  update_config {
    max_unavailable = 2
  }
  tags = {
    "Name"                                      = "${var.cluster_name}-ondemand-nodes"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "name"                                      = "${var.cluster_name}-ondemand-nodes"
  }


}

#SPOT NodeGroup
resource "aws_eks_node_group" "spot-node" {
  cluster_name    = aws_eks_cluster.eks[0].name
  node_group_name = "${var.cluster_name}-on-spot-nodes"

  node_role_arn = aws_iam_role.eks-nodegroup-role[0].arn
  subnet_ids = [
    aws_subnet.private-subnet[0].id,
    aws_subnet.private-subnet[1].id,
    aws_subnet.private-subnet[2].id
  ]

  scaling_config {
    desired_size = var.desired_capacity_on_spot
    min_size     = var.min_capacity_on_spot
    max_size     = var.max_capacity_on_spot
  }



  instance_types = var.spot_instance_types
  capacity_type  = "SPOT"

  labels = {
    type      = "spot"
    lifecycle = "spot"
  }

  update_config {
    max_unavailable = 2
  }
  tags = {
    "Name"                                      = "${var.cluster_name}-spot-nodes"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "name"                                      = "${var.cluster_name}-spot-nodes"
  }

  disk_size  = 50
  depends_on = [aws_eks_cluster.eks]
}