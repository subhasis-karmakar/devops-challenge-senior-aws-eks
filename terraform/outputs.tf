#############################################
# Networking Outputs
#############################################

output "vpc_id" {
  description = "VPC ID"

  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Public Subnet IDs"

  value = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]
}

output "private_subnet_ids" {
  description = "Private Subnet IDs"

  value = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"

  value = aws_internet_gateway.igw.id
}

output "nat_gateway_id" {
  description = "NAT Gateway ID"

  value = aws_nat_gateway.nat.id
}

#############################################
# Security Group Outputs
#############################################

output "alb_security_group_id" {
  description = "Application Load Balancer Security Group"

  value = aws_security_group.alb.id
}

output "eks_cluster_security_group_id" {
  description = "Amazon EKS Cluster Security Group"

  value = aws_security_group.eks_cluster.id
}

output "worker_node_security_group_id" {
  description = "Worker Node Security Group"

  value = aws_security_group.worker_nodes.id
}

#############################################
# IAM Outputs
#############################################

output "eks_cluster_role_arn" {
  description = "Amazon EKS Cluster IAM Role ARN"

  value = aws_iam_role.eks_cluster.arn
}

output "nodegroup_role_arn" {
  description = "Managed Node Group IAM Role ARN"

  value = aws_iam_role.nodegroup.arn
}

output "alb_controller_role_arn" {
  description = "AWS Load Balancer Controller IAM Role ARN"

  value = aws_iam_role.alb_controller.arn
}

output "oidc_provider_arn" {
  description = "OIDC Provider ARN"

  value = aws_iam_openid_connect_provider.eks.arn
}

output "oidc_provider_url" {
  description = "OIDC Provider URL"

  value = aws_iam_openid_connect_provider.eks.url
}

#############################################
# Amazon ECR Outputs
#############################################

output "ecr_repository_name" {
  description = "Amazon ECR Repository Name"

  value = aws_ecr_repository.main.name
}

output "ecr_repository_url" {
  description = "Amazon ECR Repository URL"

  value = aws_ecr_repository.main.repository_url
}

output "ecr_registry_id" {
  description = "Amazon ECR Registry ID"

  value = aws_ecr_repository.main.registry_id
}

#############################################
# Amazon EKS Outputs
#############################################

output "cluster_name" {
  description = "Amazon EKS Cluster Name"

  value = aws_eks_cluster.main.name
}

output "cluster_arn" {
  description = "Amazon EKS Cluster ARN"

  value = aws_eks_cluster.main.arn
}

output "cluster_endpoint" {
  description = "Amazon EKS Cluster Endpoint"

  value = aws_eks_cluster.main.endpoint
}

output "cluster_version" {
  description = "Amazon EKS Kubernetes Version"

  value = aws_eks_cluster.main.version
}

output "cluster_certificate_authority_data" {
  description = "Amazon EKS Cluster CA Certificate"

  value     = aws_eks_cluster.main.certificate_authority[0].data
  sensitive = true
}

#############################################
# Managed Node Group Outputs
#############################################

output "nodegroup_name" {
  description = "Managed Node Group Name"

  value = aws_eks_node_group.main.node_group_name
}

output "nodegroup_arn" {
  description = "Managed Node Group ARN"

  value = aws_eks_node_group.main.arn
}

output "nodegroup_status" {
  description = "Managed Node Group Status"

  value = aws_eks_node_group.main.status
}