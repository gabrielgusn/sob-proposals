resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace  = "kube-system"
  version = "3.11.0"

  depends_on = [ aws_eks_cluster.galoy_cluster, aws_eks_node_group.galoy_node_group ]
}