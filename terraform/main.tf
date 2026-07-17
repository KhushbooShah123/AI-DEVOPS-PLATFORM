# 1. CREATE CUSTOM VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.0"

  name = "khushboo-vpc-${var.environment}"
  cidr = local.cidr

  azs             = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets


  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Environment = var.environment
    Project     = "AI-DevOps-Platform"
  }
}

# 2. CREATE EKS CLUSTER
module "eks" {
  source       = "terraform-aws-modules/eks/aws"
  version      = "19.15.3"
  cluster_name = "khushboo-cluster-${var.environment}"

  # enable_irsa = true

  cluster_endpoint_public_access = true
  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets

  iam_role_name = "khushboo-eks-cluster-role-${var.environment}"

  # 3. WORKER NODES 
  eks_managed_node_groups = {
    default_node_group = {
      desired_size = 1
      min_size     = 1
      max_size     = 2

      instance_types = ["c7i-flex.large"]
      iam_role_name  = "khushboo-eks-node-role-${var.environment}"

      capacity_type = "SPOT"

      attach_cluster_primary_security_group = true


    }
  }

  tags = {
    Environment = var.environment
    Project     = "AI-DevOps-Platform"
  }
}

