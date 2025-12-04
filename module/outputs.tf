output "public_subnet_ids" {
  value = aws_subnet.public-subnet[*].id
}


output "cluster_security_group_id" {
  value = aws_security_group.ec2_sg.id
}


output "ec2_instance_profile_id" {
  value = aws_iam_instance_profile.ec2-instance-profile.id
}


# OIDC issuer (without https://)
output "oidc_issuer_url" {
  value = replace(aws_eks_cluster.eks[0].identity[0].oidc[0].issuer, "https://", "")
}

# OIDC provider ARN
output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.eks_oidc.arn
}
