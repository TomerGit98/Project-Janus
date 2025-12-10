terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "6.25.0"
        # profile = "terraform-user"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "6.5.1"

  name = "week-one-project-vpc"
  cidr = "10.0.0.0/16"
  azs = ["eu-central-1a", "eu-central-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.11.0/24", "10.0.12.0/24"]
  map_public_ip_on_launch = true
  enable_nat_gateway = true
  # For cost reasons I will use a single NAT gateway.
  # In a production multi-AZ setup - one_nat_gateway_per_az = true.
  single_nat_gateway = true
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "21.10.1"

  name = "week-one-project-eks"
  kubernetes_version = "1.32"
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets
  endpoint_public_access = true
  endpoint_public_access_cidrs = ["0.0.0.0/0"]
  endpoint_private_access = true
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    example = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 3
      desired_size = 2
    }
  }

  addons = {
    coredns                = {}
    kube-proxy             = {}
    vpc-cni                = { before_compute = true }
    eks-pod-identity-agent = { before_compute = true }
  }

}