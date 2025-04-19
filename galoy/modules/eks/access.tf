resource "aws_eks_access_entry" "terraform_user" {
  cluster_name  = aws_eks_cluster.galoy_cluster.name
  principal_arn = "arn:aws:iam::526703406964:user/terraform"
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "terraform_user_AmazonEKSAdminPolicy" {
  cluster_name  = aws_eks_cluster.galoy_cluster.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
  principal_arn = aws_eks_access_entry.terraform_user.principal_arn

  access_scope {
    type = "cluster"
  }
}

resource "aws_eks_access_policy_association" "terraform_user_AmazonEKSAdminClusterPolicy" {
  cluster_name  = aws_eks_cluster.galoy_cluster.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = aws_eks_access_entry.terraform_user.principal_arn

  access_scope {
    type = "cluster"
  }
}

# data "aws_iam_role" "node_role" {
#   name = aws_iam_role.eks_nodes_role.arn
# }

resource "kubernetes_config_map" "aws_auth" {

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    "mapRoles" = yamlencode([
      {
        rolearn  = aws_iam_role.eks_nodes_role.arn
        username = "system:node:{{EC2PrivateDNSName}}"
        groups = [
          "system:bootstrappers",
          "system:nodes",
        ]
      }
    ])
    "mapUsers" = yamlencode([
      {
        userarn  = "arn:aws:iam::526703406964:user/terraform" 
        username = "admin"
        groups = [
          "system:masters",
        ]
      }
    ])
    "mapUsers" = yamlencode([
      {
        userarn  = "arn:aws:iam::526703406964:user/gabrielgusn" 
        username = "admin"
        groups = [
          "system:masters",
        ]
      }
    ])
  }

  depends_on = [aws_eks_cluster.galoy_cluster]
}