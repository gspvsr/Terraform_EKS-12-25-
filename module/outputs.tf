output "public_subnet_ids" {
  value = aws_subnet.public-subnet[*].id
}


output "cluster_security_group_id" {
  value = aws_security_group.ec2_sg.id
}


output "ec2_instance_profile_id" {
  value = aws_iam_instance_profile.ec2-instance-profile.id
}
