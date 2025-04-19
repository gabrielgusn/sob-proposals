resource "aws_iam_role" "eks_role" {
    name = "${var.cluster_name}-eks-role"

    assume_role_policy = <<POLICY
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": "sts:AssumeRole",
                "Principal": {
                    "Service": "eks.amazonaws.com"
                }
            }
        ]
    }
    POLICY
}

resource "aws_iam_role" "eks_nodes_role" {
    name = "${var.cluster_name}-eks-nodes-role"

    assume_role_policy = <<POLICY
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": "sts:AssumeRole",
                "Principal": {
                    "Service": "ec2.amazonaws.com"
                }
            }
        ]
    }
    POLICY
}

resource "aws_iam_role_policy_attachment" "eks_worker_nodes_role_attachment" {
    role = aws_iam_role.eks_nodes_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
    role = aws_iam_role.eks_nodes_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks_role_attachment" {
    role = aws_iam_role.eks_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_container_registry_ro" {
  role       = aws_iam_role.eks_nodes_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_eks_cluster" "galoy_cluster" {

    depends_on = [ aws_iam_role_policy_attachment.eks_role_attachment ]

    name = "${var.cluster_name}"
    version = var.eks_version

    vpc_config {
      endpoint_private_access = false
      endpoint_public_access = true
      subnet_ids = [aws_subnet.private_subnet_az1.id, aws_subnet.private_subnet_az2.id]
    }

    role_arn = aws_iam_role.eks_role.arn
    access_config {
      authentication_mode = "API"
    }

}

resource "aws_eks_node_group" "galoy_node_group" {

    depends_on = [ 
        aws_iam_role_policy_attachment.eks_role_attachment, 
        aws_iam_role_policy_attachment.eks_cni_policy
     ]

    node_group_name = "${var.cluster_name}-general-node-group"
    version = var.eks_version
    cluster_name = aws_eks_cluster.galoy_cluster.name
    node_role_arn = aws_iam_role.eks_nodes_role.arn
    subnet_ids = [ aws_subnet.private_subnet_az1.id, aws_subnet.private_subnet_az2.id ]
    instance_types = ["t3.small"]
    capacity_type = "SPOT"

    scaling_config {
        desired_size = 1
        max_size = 1
        min_size = 1
    }

    update_config {
      max_unavailable = 1
    }

    labels = {
      role = "galoy"
    }
}