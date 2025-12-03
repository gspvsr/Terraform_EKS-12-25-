resource "aws_security_group" "eks-cluster-sg" {
  name        = var.eks-sg
  description = "allowing 443 jump server only"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbond traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.eks-sg
  }
}