# 1. CLUSTER DETAILS

output "cluster_endpoint" {
  description = "EKS Cluster API Endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "EKS Cluster Name"
  value       = module.eks.cluster_name
}

output "configure_kubectl" {
  description = "Command to connect laptop to EKS"
  value       = "aws eks --region ap-south-1 update-kubeconfig --name ${module.eks.cluster_name}"
}

# 2. VPC & NETWORKING DETAILS
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets (Where EKS nodes live)"
  value       = module.vpc.private_subnets
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets (For Load Balancers)"
  value       = module.vpc.public_subnets
}


# 3. IAM & SECURITY DETAILS
output "cluster_iam_role_arn" {
  description = "ARN of EKS Cluster IAM Role"
  value       = module.eks.cluster_iam_role_arn # <--- cluster_ add karo
}

output "node_group_iam_role_arn" {
  description = "ARN of EKS Worker Nodes IAM Role"
  value       = module.eks.eks_managed_node_groups["default_node_group"].iam_role_arn
}


