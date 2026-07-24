#############################################
# Amazon EKS Managed Node Group
#############################################

resource "aws_eks_node_group" "main" {

  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${local.name_prefix}-nodegroup"
  node_role_arn   = aws_iam_role.nodegroup.arn

  subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]

  ami_type       = var.node_ami_type
  capacity_type  = var.capacity_type
  instance_types = var.node_instance_types
  disk_size      = var.node_disk_size

  scaling_config {

    desired_size = var.desired_node_count
    min_size     = var.min_node_count
    max_size     = var.max_node_count

  }

  update_config {

    max_unavailable = 1

  }

  labels = {

    role = "worker"

  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-nodegroup"
    }
  )

  depends_on = [
    aws_eks_cluster.main,

    aws_iam_role_policy_attachment.worker_node_policy,
    aws_iam_role_policy_attachment.cni_policy,
    aws_iam_role_policy_attachment.ecr_pull_policy,
    aws_iam_role_policy_attachment.ssm_policy
  ]
}
