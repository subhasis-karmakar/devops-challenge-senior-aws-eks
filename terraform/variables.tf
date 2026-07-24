########################################
# AWS
########################################

variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "aws_profile" {
  description = "AWS CLI Profile"
  type        = string
  default     = "default"
}

########################################
# Project
########################################

variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "environment" {
  description = "Deployment Environment"
  type        = string
}

########################################
# Kubernetes
########################################

variable "kubernetes_namespace" {
  description = "Kubernetes Namespace"
  type        = string
  default     = "particle41"
}

########################################
# Networking
########################################

variable "vpc_cidr" {
  description = "VPC CIDR Block"
  type        = string
}

variable "public_subnet_1_cidr" {
  description = "Public Subnet 1 CIDR"
  type        = string
}

variable "public_subnet_2_cidr" {
  description = "Public Subnet 2 CIDR"
  type        = string
}

variable "private_subnet_1_cidr" {
  description = "Private Subnet 1 CIDR"
  type        = string
}

variable "private_subnet_2_cidr" {
  description = "Private Subnet 2 CIDR"
  type        = string
}

########################################
# Amazon EKS
########################################

variable "cluster_version" {
  description = "Amazon EKS Kubernetes Version"
  type        = string
}

########################################
# Managed Node Group
########################################

variable "node_instance_types" {
  description = "Worker node EC2 instance types"
  type        = list(string)
}

variable "capacity_type" {
  description = "Capacity type for managed node group (ON_DEMAND or SPOT)"
  type        = string
  default     = "ON_DEMAND"
}

variable "node_ami_type" {
  description = "AMI type for managed node group"
  type        = string
  default     = "AL2023_x86_64_STANDARD"
}

variable "desired_node_count" {
  description = "Desired number of worker nodes"
  type        = number
}

variable "min_node_count" {
  description = "Minimum number of worker nodes"
  type        = number
}

variable "max_node_count" {
  description = "Maximum number of worker nodes"
  type        = number
}

variable "node_disk_size" {
  description = "Worker node root volume size (GB)"
  type        = number
}

########################################
# Application
########################################

variable "application_port" {
  description = "Application container port"
  type        = number
  default     = 8000
}

########################################
# AWS Load Balancer Controller
########################################

variable "alb_controller_version" {
  description = "AWS Load Balancer Controller Helm Chart Version"
  type        = string
}