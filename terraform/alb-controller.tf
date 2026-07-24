#############################################
# AWS Load Balancer Controller IAM Policy
#############################################

resource "aws_iam_policy" "alb_controller" {

  name        = "${local.name_prefix}-alb-controller-policy"
  description = "IAM Policy for AWS Load Balancer Controller"

  policy = file("${path.module}/aws-load-balancer-controller-policy.json")

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-alb-controller-policy"
    }
  )
}

#############################################
# IAM Assume Role Policy for IRSA
#############################################

data "aws_iam_policy_document" "alb_controller_assume_role" {

  statement {

    sid    = "IRSAAssumeRole"
    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type = "Federated"

      identifiers = [
        aws_iam_openid_connect_provider.eks.arn
      ]
    }

    condition {
      test = "StringEquals"

      variable = "${replace(
        aws_iam_openid_connect_provider.eks.url,
        "https://",
        ""
      )}:sub"

      values = [
        "system:serviceaccount:kube-system:aws-load-balancer-controller"
      ]
    }

    condition {
      test = "StringEquals"

      variable = "${replace(
        aws_iam_openid_connect_provider.eks.url,
        "https://",
        ""
      )}:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }
  }
}

#############################################
# IAM Role
#############################################

resource "aws_iam_role" "alb_controller" {

  name = "${local.name_prefix}-alb-controller-role"

  assume_role_policy = data.aws_iam_policy_document.alb_controller_assume_role.json

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-alb-controller-role"
    }
  )
}

#############################################
# IAM Policy Attachment
#############################################

resource "aws_iam_role_policy_attachment" "alb_controller" {

  role       = aws_iam_role.alb_controller.name
  policy_arn = aws_iam_policy.alb_controller.arn
}

#############################################
# Kubernetes Service Account
#############################################

resource "kubernetes_service_account" "alb_controller" {

  metadata {

    name      = "aws-load-balancer-controller"
    namespace = "kube-system"

    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.alb_controller.arn
    }

    labels = {
      "app.kubernetes.io/name" = "aws-load-balancer-controller"
    }
  }

  depends_on = [
    aws_eks_node_group.main
  ]
}

#############################################
# Helm Release
#############################################

resource "helm_release" "alb_controller" {

  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"

  version = var.alb_controller_version

  namespace        = "kube-system"
  create_namespace = false

  wait            = true
  timeout         = 600
  atomic          = true
  cleanup_on_fail = true

  set = [
    {
      name  = "clusterName"
      value = aws_eks_cluster.main.name
    },
    {
      name  = "region"
      value = var.aws_region
    },
    {
      name  = "vpcId"
      value = aws_vpc.main.id
    },
    {
      name  = "serviceAccount.create"
      value = "false"
    },
    {
      name  = "serviceAccount.name"
      value = kubernetes_service_account.alb_controller.metadata[0].name
    }
  ]

  depends_on = [
    aws_iam_role_policy_attachment.alb_controller,
    kubernetes_service_account.alb_controller
  ]
}
