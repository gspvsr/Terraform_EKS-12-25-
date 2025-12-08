resource "helm_release" "aws_load_balancer_controller" {
  name               = "aws-load-balancer-controller"
  # ➡️ CORRECTION: Best practice is to use the chart name for the namespace
  # or 'kube-system' (but your defined namespace name is also acceptable if pre-created)
  namespace          = "aws-loadbalancer-controller" 
  
  repository         = "https://aws.github.io/eks-charts"
  chart              = "aws-load-balancer-controller"
  version            = "1.16.0" 

  create_namespace   = true

  # CRITICAL: Ensures the controller has time to come up before dependent resources
  timeout = 300

  set = [
    {
      name  = "clusterName"
      value = var.cluster_name
    },
    {
      # Assumes you created the ServiceAccount via 'eksctl' or 'aws_iam_role' and 'kubernetes_service_account'
      name  = "serviceAccount.create"
      value = "false" 
    },
    {
      # This MUST match the pre-created ServiceAccount name with the IAM Role ARN annotation
      name  = "serviceAccount.name"
      value = "aws-load-balancer-controller"
    },
    {
      # This is a required value for the controller to function in the correct region
      name  = "awsRegion" 
      value = var.aws-region # Changed to follow standard variable naming, ensure your variable is spelled correctly
    },
    {
      # Recommended to enable the webhook for service type LoadBalancer mutation
      name  = "enableServiceMutatorWebhook"
      value = "true" 
    }
  ]
}