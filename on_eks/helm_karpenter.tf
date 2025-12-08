# 1. Install Karpenter CRDs (Custom Resource Definitions)
resource "helm_release" "karpenter_crd" {
  name             = "karpenter-crd"
  namespace        = "karpenter"

  repository       = "oci://public.ecr.aws/karpenter"
  chart            = "karpenter-crd"
  version          = "1.8.2"

  create_namespace = true
}

# 2. Install Karpenter Controller
resource "helm_release" "karpenter" {
  name             = "karpenter"
  namespace        = "karpenter"

  repository       = "oci://public.ecr.aws/karpenter"
  chart            = "karpenter"
  version          = "1.8.2"

  create_namespace = true
  depends_on       = [helm_release.karpenter_crd]

  set {
    name  = "settings.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "settings.clusterEndpoint"
    value = data.aws_eks_cluster.eks-cluster.endpoint
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.karpenter_controller.arn
  }
}
