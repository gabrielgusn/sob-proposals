terraform {
  required_version = ">= 1.11.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.36.0"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = var.profile
}

provider "kubernetes" {
  host = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca_data)
  token = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    host = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_ca_data)
    token = data.aws_eks_cluster_auth.this.token
  }
}

module "budget" {
  source = "./modules/budget"
}

module "ec2" {
  source = "./modules/ec2"
}

module "eks" {
  source = "./modules/eks"
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}

# module "s3" {
#   source = "./modules/s3"
# }

# output "instance_ip" {
#   value = module.ec2.free_tier_instance_ip
# }

# output "nat_ip" {
#   value = module.eks.nat_ip
# }