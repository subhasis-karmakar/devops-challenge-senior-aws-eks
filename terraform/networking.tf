#############################################
# VPC
#############################################

resource "aws_vpc" "main" {

  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    local.common_tags,
    {
      Name = local.vpc_name
    }
  )
}

#############################################
# Internet Gateway
#############################################

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = local.igw_name
    }
  )
}

#############################################
# Elastic IP
#############################################

resource "aws_eip" "nat" {

  domain = "vpc"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.nat_gateway_name}-eip"
    }
  )

  depends_on = [
    aws_internet_gateway.igw
  ]
}

#############################################
# Public Subnet 1
#############################################

resource "aws_subnet" "public_1" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.public_subnet_1_cidr

  availability_zone = data.aws_availability_zones.available.names[0]

  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-public-1"

      "kubernetes.io/role/elb" = "1"

      "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    }
  )
}

#############################################
# Public Subnet 2
#############################################

resource "aws_subnet" "public_2" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.public_subnet_2_cidr

  availability_zone = data.aws_availability_zones.available.names[1]

  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-public-2"

      "kubernetes.io/role/elb" = "1"

      "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    }
  )
}

#############################################
# Private Subnet 1
#############################################

resource "aws_subnet" "private_1" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.private_subnet_1_cidr

  availability_zone = data.aws_availability_zones.available.names[0]

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-private-1"

      "kubernetes.io/role/internal-elb" = "1"

      "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    }
  )
}

#############################################
# Private Subnet 2
#############################################

resource "aws_subnet" "private_2" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.private_subnet_2_cidr

  availability_zone = data.aws_availability_zones.available.names[1]

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-private-2"

      "kubernetes.io/role/internal-elb" = "1"

      "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    }
  )
}

#############################################
# NAT Gateway
#############################################

resource "aws_nat_gateway" "nat" {

  allocation_id = aws_eip.nat.id

  subnet_id = aws_subnet.public_1.id

  tags = merge(
    local.common_tags,
    {
      Name = local.nat_gateway_name
    }
  )

  depends_on = [
    aws_internet_gateway.igw
  ]
}

#############################################
# Public Route Table
#############################################

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.main.id

  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    local.common_tags,
    {
      Name = local.public_rt_name
    }
  )
}

#############################################
# Private Route Table
#############################################

resource "aws_route_table" "private" {

  vpc_id = aws_vpc.main.id

  route {

    cidr_block = "0.0.0.0/0"

    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = merge(
    local.common_tags,
    {
      Name = local.private_rt_name
    }
  )
}

#############################################
# Public Route Table Associations
#############################################

resource "aws_route_table_association" "public_1" {

  subnet_id = aws_subnet.public_1.id

  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {

  subnet_id = aws_subnet.public_2.id

  route_table_id = aws_route_table.public.id
}

#############################################
# Private Route Table Associations
#############################################

resource "aws_route_table_association" "private_1" {

  subnet_id = aws_subnet.private_1.id

  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_2" {

  subnet_id = aws_subnet.private_2.id

  route_table_id = aws_route_table.private.id
}