resource "helm_release" "karpenter" {
  name       = "karpenter"
  namespace  = "karpenter"
  repository = "https://charts.karpenter.sh"
  chart      = "karpenter"
  version    = "v0.36.1"  # <- updated version
  create_namespace = true

  set = [
    {
      name  = "clusterName"
      value = var.cluster_name
    },
    {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = aws_iam_role.karpenter_controller.arn
    },
    {
      name  = "controller.clusterEndpoint"
      value = data.aws_eks_cluster.eks-cluster.endpoint
    }
  ]
}
