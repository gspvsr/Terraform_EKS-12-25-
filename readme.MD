for EKS
    - Create VPC
    - I am Roles in Policies
    - EKS Cluster
    - add ons
    - Worker Nodes.

for VPC:
    - VPC Config, maximum variablize all
    - IGW
    - pubic subnet
    - public subnet rt
    - puiblic subnet rta
    - security groups needs to be created

after completion of above steps, we will do following IAM Roles.
1. EKS Cluster Role = Permissions for cluster control plane (eks.amazonaws.com)
2. Worker Node Role = Permissions for EC2 nodes (ec2.amazonaws.com)
then we need to create policy and attach to this roles
3. I am gathered required policy and TLS certificate.

A. Eks cluster
B. OPN ID Provider
C. Created Addons
D. Created NodeGroups
    type : ondemond & spot
