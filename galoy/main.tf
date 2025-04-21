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
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.17.0"
    }

    local = {
      source = "hashicorp/local"
      version = "~> 2.5.2"
    }

    tls = {
      source = "hashicorp/tls"
      version = "4.0.6"
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
  token = data.aws_eks_cluster_auth.galoy_cluster_auth.token
}

provider "helm" {
  kubernetes {
    host = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_ca_data)
    token = data.aws_eks_cluster_auth.galoy_cluster_auth.token
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

data "aws_eks_cluster_auth" "galoy_cluster_auth" {
  name = module.eks.cluster_name
}