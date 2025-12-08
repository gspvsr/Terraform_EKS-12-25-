locals {
  lb_controller_sub = "${replace(data.aws_eks_cluster.eks-cluster.identity[0].oidc[0].issuer, "https://", "")}:sub"
}

# IAM Policy
resource "aws_iam_policy" "lb-controller-policy" {
  name   = "AWSLoadBalancerControllerIAMPolicy"
  policy = file("iam_policy.json")
}

# IAM Role
resource "aws_iam_role" "lb_controller_role" {
  name = "AWSLoadBalancerControllerRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "sts:AssumeRoleWithWebIdentity"
      Principal = {
        Federated = data.aws_iam_openid_connect_provider.eks.arn
      }
      Condition = {
        StringEquals = {
          "${local.lb_controller_sub}" = "system:serviceaccount:aws-loadbalancer-controller:aws-load-balancer-controller"
        }
      }
    }]
  })
}

# Attach Policy to Role
resource "aws_iam_role_policy_attachment" "alb_attach" {
  role       = aws_iam_role.lb_controller_role.name
  policy_arn = aws_iam_policy.lb-controller-policy.arn
}

# Kubernetes Namespace
resource "kubernetes_namespace" "aws_lb_ns" {
  metadata {
    name = "aws-loadbalancer-controller"
  }
}

# Service Account
resource "kubernetes_service_account" "lb_controller" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "aws-loadbalancer-controller"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.lb_controller_role.arn
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.alb_attach,
    kubernetes_namespace.aws_lb_ns
  ]
}
