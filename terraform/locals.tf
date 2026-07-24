locals {

  ####################################
  # Naming Convention
  ####################################

  name_prefix = "${var.project_name}-${var.environment}"

  cluster_name        = "${local.name_prefix}-eks"
  ecr_repository_name = "${local.name_prefix}-ecr"

  vpc_name         = "${local.name_prefix}-vpc"
  igw_name         = "${local.name_prefix}-igw"
  nat_gateway_name = "${local.name_prefix}-nat"

  public_rt_name  = "${local.name_prefix}-public-rt"
  private_rt_name = "${local.name_prefix}-private-rt"

  nodegroup_name = "${local.name_prefix}-nodegroup"

  alb_name = "${local.name_prefix}-alb"

  ####################################
  # Common Tags
  ####################################

  common_tags = {

    Project     = var.project_name
    Environment = var.environment

    ManagedBy = "Terraform"

    Repository = "devops-challenge-senior"

  }

}