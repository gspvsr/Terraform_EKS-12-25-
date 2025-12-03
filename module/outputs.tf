output "public_subnet_ids" {
  value = aws_subnet.public-subnet[*].id
}


output "cluster_security_group_id" {
  value = aws_security_group.eks-cluster-sg.id
}
