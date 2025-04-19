variable "region" {
    default = "us-east-1"
    type = string
    description = "AWS Region"
}

variable "project" {
    default = "galoy-test"
    type = string
    description = "Project Name"
}

variable "zone1" {
    default = "us-east-1a"
    type = string
    description = "AWS Zone"
}

variable "zone2" {
    default = "us-east-1b"
    type = string
    description = "AWS Zone"
}

variable "eks_version" {
    default = "1.32"
    type = string
    description = "Kubernetes Version"
}

variable "cluster_name" {
    default = "galoy-test-cluster"
    type = string
    description = "EKS Cluster Name"
}