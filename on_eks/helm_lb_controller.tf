resource "helm_release" "aws_load_balancer_controller" {
  name               = "aws-load-balancer-controller"
  namespace          = "aws-loadbalancer-controller"
  repository         = "https://aws.github.io/eks-charts"
  chart              = "aws-loadbalancer-controller"
  version            = "1.16.0" # <--- Recommended Update

  create_namespace   = true # A common pattern to ensure the namespace exists

  set = [
    {
      name  = "clusterName"
      value = var.cluster_name
    },
    {
      name  = "serviceAccount.create"
      value = "false" # Assumes you pre-created the ServiceAccount and IAM Role (IRSA)
    },
    {
      name  = "serviceAccount.name"
      value = "aws-load-balancer-controller"
    },
    {
      name  = "region"
      value = var.aws-region
    }
  ]
}