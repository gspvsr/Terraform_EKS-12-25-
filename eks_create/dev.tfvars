env          = "dev"
aws-region   = "us-east-1"
cidr-block   = "10.16.0.0/16"
cluster_name = "eks-prod"
vpc-name     = "vpc-prod"

igw-name                 = "prod-igw"
pub-cidr-block           = ["10.16.16.0/24", "10.16.32.0/24", "10.16.64.0/24"]
pub-availability_zone    = ["us-east-1a", "us-east-1b", "us-east-1c"]
pub-sub-name             = "pub-subnet"
pvt-sub-name             = "pvt-subnet"
pvt-cidr-block           = ["10.16.128.0/24", "10.16.144.0/24", "10.16.160.0/24"]
public-rt-name           = "public-rt"
ngw-name                 = "prod-ngw"
private-rt-name          = "private-rt"
eks-sg                   = "eks-sg"
is_eks_role_enabled      = "true"
is_eks_nodegroup_enabled = "true"
is-eks-cluster-enabled   = "true"
cluster-version          = "1.33"
endpoint-private-access  = true
endpoint-public-access   = false
addons = [
  {
    name    = "vpc-cni"
    version = "v1.20.0-eksbuild.1"
  },
  {
    name    = "coredns"
    version = "v1.12.2-eksbuild.1"
  },
  {
    name    = "kube-proxy"
    version = "v1.33.5-eksbuild.2"  # <-- valid for cluster 1.33
  },
  {
    name    = "aws-ebs-csi-driver"
    version = "v1.46.0-eksbuild.1"
  }
]


desired_capacity_on_demand = 1
min_capacity_on_demand     = 1
max_capacity_on_demand     = 4
ondemand_instance_types    = ["t3a.medium", "t3.medium", "t2.medium", "m5.large", "m5a.large"]


desired_capacity_on_spot = 1
min_capacity_on_spot     = 1
max_capacity_on_spot     = 3
spot_instance_types      = ["c5a.large", "c5a.xlarge", "m5a.large", "m5a.xlarge", "c5.large"]


ec2-iam-role = "ec2-ssm-role"
ec2-iam-role-policy = "ec2-ssm-role-policy"
ec2-iam-instance-profile = "ec2-ssm-instance-profile"

ec2_name = "dev"
ec2_sg = "ec2_sg"

