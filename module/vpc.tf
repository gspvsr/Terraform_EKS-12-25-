resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr-block
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = var.vpc-name
    ENV  = var.env
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name                                          = var.igw-name
    ENV                                           = var.env
    "kubernetes.io/cluster/${local.cluster_name}" = "owned"
  }

  depends_on = [aws_vpc.vpc]
}


resource "aws_subnet" "public-subnet" {
  count                   = length(var.pub-cidr-block)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.pub-cidr-block, count.index)
  availability_zone       = element(var.pub-availability_zone, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name                                          = "${var.pub-sub-name}-${count.index + 1}"
    ENV                                           = var.env
    "kubernetes.io/cluster/${local.cluster_name}" = "owned"
    "kubernetes.io/roles/internal-elb"            = "1"
  }
  depends_on = [aws_vpc.vpc]
}

resource "aws_subnet" "private-subnet" {
  count                   = length(var.pvt-cidr-block)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.pvt-cidr-block, count.index)
  availability_zone       = element(var.pub-availability_zone, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name                                          = "${var.pvt-sub-name}-${count.index + 1}"
    ENV                                           = var.env
    "kubernetes.io/cluster/${local.cluster_name}" = "owned"
    "kubernetes.io/roles/internal-elb"            = "1"
  }
  depends_on = [aws_vpc.vpc]
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.public-rt-name
    env  = var.env
  }

  depends_on = [aws_vpc.vpc]
}

resource "aws_route_table_association" "pub-rta" {
  count                   = length(var.pub-cidr-block)
  subnet_id      = aws_subnet.public-subnet[count.index].id
  route_table_id = aws_route_table.public-rt.id

  depends_on = [aws_vpc.vpc, aws_subnet.public-subnet]
}

resource "aws_eip" "ngw-ip" {
  domain = "vpc"
}


resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.ngw-ip.id
  subnet_id     = aws_subnet.public-subnet[0].id

  tags = {
    Name = var.ngw-name
  }

  depends_on = [aws_vpc.vpc, aws_eip.ngw-ip]
}



resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }

  tags = {
    Name = var.private-rt-name
    env  = var.env
  }

  depends_on = [aws_vpc.vpc, aws_subnet.private-subnet]
}

resource "aws_route_table_association" "pvt-rta" {
  count                   = length(var.pvt-cidr-block)
  subnet_id      = aws_subnet.private-subnet[count.index].id
  route_table_id = aws_route_table.private-rt.id

  depends_on = [aws_vpc.vpc, aws_subnet.private-subnet]
}