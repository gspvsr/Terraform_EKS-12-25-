# 1. Install Karpenter CRDs (Custom Resource Definitions)
resource "helm_release" "karpenter_crd" {
  # This resource must be defined because your main 'karpenter' release depends on it.
  name             = "karpenter-crd"
  namespace        = "karpenter"
  
  # Ensure the repository, chart, and version match the main controller settings
  repository       = "oci://public.ecr.aws/karpenter"
  chart            = "karpenter-crd"
  version          = "1.8.2" 
  create_namespace = true
}


resource "helm_release" "karpenter" {
  name               = "karpenter"
  namespace          = "karpenter"
  repository         = "oci://public.ecr.aws/karpenter"
  chart              = "karpenter"
  version            = "1.8.2" 
  create_namespace   = true

  # ➡️ CRITICAL: Ensures CRDs are applied before the controller deployment
  depends_on         = [helm_release.karpenter_crd] 

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