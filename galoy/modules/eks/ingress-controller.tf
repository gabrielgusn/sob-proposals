resource "helm_release" "nginx-ingress" {
  name       = "ingress-nginx"
  namespace = "nginx"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx"
  version    = "13.2.29"
  create_namespace = true

  depends_on = [
    null_resource.apply_aws_auth,
    aws_eks_cluster.galoy_cluster,
    aws_eks_node_group.galoy_node_group
  ]
}