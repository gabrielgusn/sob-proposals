output "cluster_name" {
    value = aws_eks_cluster.galoy_cluster.name
}

output "cluster_ca_data" {
    value = aws_eks_cluster.galoy_cluster.certificate_authority[0].data
}

output "cluster_endpoint" {
    value = aws_eks_cluster.galoy_cluster.endpoint
}

