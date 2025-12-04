AWS LoadBalancer Controller [Role, Policies]
Service Accounts and LB Controller

ArgoCD
Kube-Prometheus_Grafana stack
Helm


-----------------------------------

helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=ap-medium \
  --set serviceAccount.create=false \
  --set region=us-east-1 \
  --set vpcId=vpc-00f1fc9d36ef36680 \
  --set serviceAccount.name=aws-load-balancer-controller \
  --version 1.14.0

----------------------------------------------