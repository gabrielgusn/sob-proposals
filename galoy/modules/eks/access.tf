resource "aws_eks_access_entry" "terraform_user" {
  cluster_name  = aws_eks_cluster.galoy_cluster.name
  principal_arn = "arn:aws:iam::526703406964:user/terraform"
  type          = "STANDARD"
  depends_on = [ aws_eks_cluster.galoy_cluster ]
}

resource "aws_eks_access_policy_association" "terraform_user_AmazonEKSAdminPolicy" {
  cluster_name  = aws_eks_cluster.galoy_cluster.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
  principal_arn = aws_eks_access_entry.terraform_user.principal_arn

  depends_on = [ aws_eks_cluster.galoy_cluster, aws_eks_access_entry.terraform_user ]

  access_scope {
    type = "cluster"
  }
}

resource "aws_eks_access_policy_association" "terraform_user_AmazonEKSAdminClusterPolicy" {
  cluster_name  = aws_eks_cluster.galoy_cluster.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = aws_eks_access_entry.terraform_user.principal_arn

  depends_on = [ aws_eks_cluster.galoy_cluster, aws_eks_access_entry.terraform_user ]

  access_scope {
    type = "cluster"
  }
}

resource "null_resource" "apply_aws_auth" {
  triggers = {
    cluster_endpoint = aws_eks_cluster.galoy_cluster.endpoint # Replace aws_eks_cluster.this with your cluster resource name
  }

  # Ensure this runs after the cluster is created and potentially after nodes are ready
  depends_on = [
    aws_eks_cluster.galoy_cluster,
    aws_eks_node_group.galoy_node_group,
    aws_eks_access_entry.terraform_user,
    aws_eks_access_policy_association.terraform_user_AmazonEKSAdminClusterPolicy,
    aws_eks_access_policy_association.terraform_user_AmazonEKSAdminPolicy,
    # Optionally add dependency on node group if nodes need to be registered first, though usually not required for aws-auth
  ]

  provisioner "local-exec" {
    # This command assumes AWS CLI v2 and kubectl are installed where Terraform runs
    # It uses the AWS credentials configured for Terraform (which should be the cluster creator)
    # to update kubeconfig and apply the aws-auth map.
    command = <<-EOT
      aws eks update-kubeconfig --region ${var.region} --name ${aws_eks_cluster.galoy_cluster.name} --alias ${aws_eks_cluster.galoy_cluster.name} --kubeconfig ${path.module}/config.yaml --profile terraform
    EOT
    # Use interpreter based on your OS if needed, e.g., ["/bin/bash", "-c"]
  }

  # Optional: Add a destroy-time provisioner if you want to clean up the kubectl context entry
  # provisioner "local-exec" {
  #   when    = destroy
  #   command = "kubectl config delete-context ${aws_eks_cluster.this.name}"
  # }
}

# Helper local variable for kubeconfig path and profile argument
locals {
  # kubeconfig_path       = pathexpand("./config.yaml") # Default kubeconfig path
  # If you use a specific AWS profile for the terraform user (as in config.yaml),
  # but the cluster was created by a DIFFERENT profile/role, ensure the local-exec runs
  # with the CREATOR's credentials. If the terraform user IS the creator, this is fine.
  # The --profile argument for update-kubeconfig should match the credentials used for applying.
  # Adjust profile_name if necessary or remove --profile if using default creds/instance role.
  profile_name          = "terraform" # Or determine dynamically if needed
  kubeconfig_profile_arg = local.profile_name != "" ? "--profile ${local.profile_name}" : ""

  # You might need to adjust the aws-auth path if it's not in the root module directory
  # aws_auth_configmap_path = "${path.module}/galoy/aws-auth-cm.yaml" # Adjust if needed
}