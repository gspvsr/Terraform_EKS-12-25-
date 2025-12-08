resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.7.1"

  set = [
    { name = "clusterName"       , value = var.cluster_name },
    { name = "region"            , value = var.aws_region },
    { name = "vpcId"             , value = data.aws_vpc.vpc.id },
    { name = "serviceAccount.create", value = "false" },
    { name = "serviceAccount.name", value = "aws-load-balancer-controller" }
  ]

  depends_on = [
    kubernetes_service_account.lb_controller
  ]
}
