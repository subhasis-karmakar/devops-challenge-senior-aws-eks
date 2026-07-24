#############################################
# Amazon EKS Cluster
#############################################

resource "aws_eks_cluster" "main" {

  name     = local.cluster_name
  version  = var.cluster_version
  role_arn = aws_iam_role.eks_cluster.arn

  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  vpc_config {

    subnet_ids = [
      aws_subnet.private_1.id,
      aws_subnet.private_2.id
    ]

    security_group_ids = [
      aws_security_group.eks_cluster.id
    ]

    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"]
  }

  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator"
  ]

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_vpc_resource_controller
  ]

  tags = merge(
    local.common_tags,
    {
      Name = local.cluster_name
    }
  )
}

#############################################
# EKS Authentication
#############################################

data "aws_eks_cluster_auth" "main" {
  name = aws_eks_cluster.main.name
}

#############################################
# Kubernetes Provider
#############################################

provider "kubernetes" {

  host = aws_eks_cluster.main.endpoint
  cluster_ca_certificate = base64decode(
    aws_eks_cluster.main.certificate_authority[0].data
  )
  token = data.aws_eks_cluster_auth.main.token
}

#############################################
# Helm Provider
#############################################
provider "helm" {

  kubernetes = {
    host = aws_eks_cluster.main.endpoint

    cluster_ca_certificate = base64decode(
      aws_eks_cluster.main.certificate_authority[0].data
    )

    token = data.aws_eks_cluster_auth.main.token
  }
}
