#############################################
# Application Load Balancer Security Group
#############################################

resource "aws_security_group" "alb" {

  name        = "${local.name_prefix}-alb-sg"
  description = "Security Group for Application Load Balancer"

  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-alb-sg"
    }
  )
}

#############################################
# Amazon EKS Control Plane Security Group
#############################################

resource "aws_security_group" "eks_cluster" {

  name        = "${local.cluster_name}-cluster-sg"
  description = "Security Group for Amazon EKS Control Plane"

  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.cluster_name}-cluster-sg"
    }
  )
}

#############################################
# Amazon EKS Worker Nodes Security Group
#############################################

resource "aws_security_group" "worker_nodes" {

  name        = "${local.nodegroup_name}-sg"
  description = "Security Group for Amazon EKS Worker Nodes"

  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.nodegroup_name}-sg"
    }
  )
}

#############################################
# ALB Security Group Rules
#############################################

resource "aws_vpc_security_group_ingress_rule" "alb_http" {

  security_group_id = aws_security_group.alb.id

  description = "Allow HTTP from Internet"

  cidr_ipv4 = "0.0.0.0/0"

  ip_protocol = "tcp"

  from_port = 80
  to_port   = 80
}

resource "aws_vpc_security_group_ingress_rule" "alb_https" {

  security_group_id = aws_security_group.alb.id

  description = "Allow HTTPS from Internet"

  cidr_ipv4 = "0.0.0.0/0"

  ip_protocol = "tcp"

  from_port = 443
  to_port   = 443
}

resource "aws_vpc_security_group_egress_rule" "alb_to_workers" {

  security_group_id = aws_security_group.alb.id

  description = "ALB to Worker Nodes"

  referenced_security_group_id = aws_security_group.worker_nodes.id

  ip_protocol = "tcp"

  from_port = var.application_port
  to_port   = var.application_port
}

#############################################
# EKS Control Plane Security Group Rules
#############################################

resource "aws_vpc_security_group_egress_rule" "cluster_to_workers_https" {

  security_group_id = aws_security_group.eks_cluster.id

  description = "Control Plane to Worker Nodes"

  referenced_security_group_id = aws_security_group.worker_nodes.id

  ip_protocol = "tcp"

  from_port = 443
  to_port   = 443
}

#############################################
# Worker Nodes Security Group Rules
#############################################

resource "aws_vpc_security_group_ingress_rule" "workers_from_alb" {

  security_group_id = aws_security_group.worker_nodes.id

  description = "Application traffic from ALB"

  referenced_security_group_id = aws_security_group.alb.id

  ip_protocol = "tcp"

  from_port = var.application_port
  to_port   = var.application_port
}

resource "aws_vpc_security_group_ingress_rule" "workers_from_cluster_https" {

  security_group_id = aws_security_group.worker_nodes.id

  description = "HTTPS from EKS Control Plane"

  referenced_security_group_id = aws_security_group.eks_cluster.id

  ip_protocol = "tcp"

  from_port = 443
  to_port   = 443
}

resource "aws_vpc_security_group_ingress_rule" "workers_from_cluster_kubelet" {

  security_group_id = aws_security_group.worker_nodes.id

  description = "Kubelet from EKS Control Plane"

  referenced_security_group_id = aws_security_group.eks_cluster.id

  ip_protocol = "tcp"

  from_port = 10250
  to_port   = 10250
}

resource "aws_vpc_security_group_ingress_rule" "workers_node_to_node" {

  security_group_id = aws_security_group.worker_nodes.id

  description = "Node to Node communication"

  referenced_security_group_id = aws_security_group.worker_nodes.id

  ip_protocol = "-1"
}

resource "aws_vpc_security_group_egress_rule" "workers_internet" {

  security_group_id = aws_security_group.worker_nodes.id

  description = "Outbound Internet"

  cidr_ipv4 = "0.0.0.0/0"

  ip_protocol = "-1"
}

resource "aws_vpc_security_group_egress_rule" "workers_to_cluster" {

  security_group_id = aws_security_group.worker_nodes.id

  description = "Worker Nodes to EKS Control Plane"

  referenced_security_group_id = aws_security_group.eks_cluster.id

  ip_protocol = "tcp"

  from_port = 443
  to_port   = 443
}