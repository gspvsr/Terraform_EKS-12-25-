variable "aws-region" {}
variable "cidr-block" {}
variable "cluster_name" {}
variable "vpc-name" {}
variable "env" {}
variable "igw-name" {}
variable "pub-cidr-block" {}
variable "pub-availability_zone" {}
variable "pub-sub-name" {}
variable "pvt-sub-name" {}
variable "pvt-cidr-block" {}
variable "public-rt-name" {}
variable "ngw-name" {}
variable "private-rt-name" {}
variable "eks-sg" {}
variable "is_eks_role_enabled" {}
variable "is_eks_nodegroup_enabled" {
  type = bool
}
variable "is-eks-cluster-enabled" {
  type = bool
}
variable "cluster-version" {}
variable "endpoint-private-access" {}
variable "endpoint-public-access" {}
variable "addons" {
  type = list(object({
    name    = string
    version = string
  }))
}

variable "desired_capacity_on_demand" {}
variable "min_capacity_on_demand" {}
variable "max_capacity_on_demand" {}
variable "ondemand_instance_types" {}

variable "desired_capacity_on_spot" {}
variable "min_capacity_on_spot" {}
variable "max_capacity_on_spot" {}
variable "spot_instance_types" {}


# IAM
variable "ec2-iam-role" {}
variable "ec2-iam-role-policy" {}
variable "ec2-iam-instance-profile" {}

# EC2
variable "ec2_name" {}
variable "ec2_sg" {}