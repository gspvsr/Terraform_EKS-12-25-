resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  namespace  = "aws-loadbalancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-loadbalancer-controller"
  version    = "1.5.3"

  set = [
    {
      name  = "clusterName"
      value = var.cluster_name
    },
    {
      name  = "serviceAccount.create"
      value = "false"
    },
    {
      name  = "serviceAccount.name"
      value = "aws-load-balancer-controller"
    },
    {
      name  = "region"
      value = var.region
    }
  ]
}
