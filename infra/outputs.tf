variable "environment" {
  type        = string
  default     = "dev"
  description = "The deployment environment (dev/staging/prod)"
}

output "common_tags" {
  value = {
    Project     = "week1-go-microservice"
    Environment = var.environment
    Owner       = "Tomer"
    CostCenter  = "DevOps-Learning"
  }
}

# VPC Outputs
output "VPC_ID" {
  value = module.vpc.vpc_id
}
output "VPC_Private_Subnets" {
  value = module.vpc.private_subnets
}
output "VPC_Public_Subnets" {
  value = module.vpc.public_subnets
}

# EKS Cluster Outputs
output "Cluster_Name" {
  value = module.eks.cluster_name
}
output "Cluster_Endpoint" {
  value = module.eks.cluster_endpoint
}
output "Cluster_Cert_Auth_Data" {
  value = module.eks.cluster_certificate_authority_data
}
output "Cluster_Security_Group_ID" {
  value = module.eks.cluster_security_group_id
}

#Node Group Outputs
output "Node_Group_Role" {
  value = module.eks.node_security_group_arn
}
output "Node_Group_Name" {
  value = module.eks.node_iam_role_name
}