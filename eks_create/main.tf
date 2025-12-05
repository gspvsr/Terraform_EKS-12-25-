module "eks" {
  source       = "../module"
  cidr-block   = var.cidr-block
  cluster_name = local.org
  vpc-name     = var.vpc-name
  env          = var.env
  igw-name     = var.igw-name
  ngw-name     = var.ngw-name

  pub-cidr-block        = var.pub-cidr-block
  pub-availability_zone = var.pub-availability_zone
  pub-sub-name          = var.pub-sub-name

  pvt-sub-name   = var.pvt-sub-name
  pvt-cidr-block = var.pvt-cidr-block

  public-rt-name  = var.public-rt-name
  private-rt-name = var.private-rt-name

  eks-sg                   = var.eks-sg
  is_eks_role_enabled      = var.is_eks_role_enabled
  is_eks_nodegroup_enabled = var.is_eks_nodegroup_enabled
  is-eks-cluster-enabled   = var.is-eks-cluster-enabled

  cluster-version         = var.cluster-version
  endpoint-private-access = var.endpoint-private-access
  endpoint-public-access  = var.endpoint-public-access
  addons                  = var.addons

  desired_capacity_on_demand = var.desired_capacity_on_demand
  min_capacity_on_demand     = var.min_capacity_on_demand
  max_capacity_on_demand     = var.max_capacity_on_demand
  ondemand_instance_types    = var.ondemand_instance_types

  desired_capacity_on_spot = var.desired_capacity_on_spot
  min_capacity_on_spot     = var.min_capacity_on_spot
  max_capacity_on_spot     = var.max_capacity_on_spot
  spot_instance_types      = var.spot_instance_types
  aws-region               = var.aws-region



  # IAM
  ec2-iam-role             = var.ec2-iam-role
  ec2-iam-role-policy      = var.ec2-iam-role-policy
  ec2-iam-instance-profile = var.ec2-iam-instance-profile

  #EC2
  ec2_name = var.ec2_name
  ec2_sg   = var.ec2_sg
}


