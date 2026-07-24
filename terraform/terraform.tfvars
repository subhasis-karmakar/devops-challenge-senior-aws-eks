########################################
# AWS
########################################

aws_region  = "us-east-1"
aws_profile = "default"

########################################
# Project
########################################

project_name = "particle41"
environment  = "dev"

########################################
# Kubernetes
########################################

kubernetes_namespace = "particle41"

########################################
# Networking
########################################

vpc_cidr = "10.0.0.0/16"

public_subnet_1_cidr = "10.0.1.0/24"
public_subnet_2_cidr = "10.0.2.0/24"

private_subnet_1_cidr = "10.0.11.0/24"
private_subnet_2_cidr = "10.0.12.0/24"

########################################
# Amazon EKS
########################################

cluster_version = "1.33"

########################################
# Managed Node Group
########################################

node_instance_types = [
  "t3.small"
]

capacity_type = "ON_DEMAND"

node_ami_type = "AL2023_x86_64_STANDARD"

desired_node_count = 2

min_node_count = 2

max_node_count = 4

node_disk_size = 20

########################################
# Application
########################################

application_port = 8000

#########################################
# AWS Load Balancer Controller
#########################################

alb_controller_version = "1.13.0"
