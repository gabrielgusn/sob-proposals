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

resource "aws_iam_role_policy_attachment" "eks_role_attachment" {
    role = aws_iam_role.eks_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    depends_on = [
        aws_iam_role.eks_role
    ]
}

resource "aws_iam_role_policy_attachment" "eks_worker_nodes_role_attachment" {
    role = aws_iam_role.eks_nodes_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    depends_on = [
        aws_iam_role.eks_nodes_role
    ]
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
    role = aws_iam_role.eks_nodes_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    depends_on = [
        aws_iam_role.eks_nodes_role
    ]
}


resource "aws_iam_role_policy_attachment" "eks_container_registry_ro" {
  role       = aws_iam_role.eks_nodes_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  depends_on = [
    aws_iam_role.eks_nodes_role
  ]
}

resource "aws_eks_cluster" "galoy_cluster" {

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

    depends_on = [ 
        aws_iam_role_policy_attachment.eks_role_attachment,
        aws_iam_role_policy_attachment.eks_cni_policy,
        aws_iam_role_policy_attachment.eks_container_registry_ro,
        aws_iam_role_policy_attachment.eks_worker_nodes_role_attachment,
        aws_vpc.cluster_vpc,
        aws_subnet.private_subnet_az1,
        aws_subnet.private_subnet_az2,
        aws_route_table.cluster_prv_rt,
        aws_route_table.cluster_pub_rt,
        aws_iam_role.eks_role,
        aws_iam_role.eks_nodes_role,
        aws_route_table_association.cluster_prv_sn_az1_association,
        aws_route_table_association.cluster_prv_sn_az2_association,
        aws_route_table_association.cluster_pub_sn_az1_association,
        aws_route_table_association.cluster_pub_sn_az2_association,
    ]

}

resource "aws_eks_node_group" "galoy_node_group" {

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

    depends_on = [ 
        aws_iam_role_policy_attachment.eks_role_attachment,
        aws_iam_role_policy_attachment.eks_cni_policy,
        aws_iam_role_policy_attachment.eks_container_registry_ro,
        aws_iam_role_policy_attachment.eks_worker_nodes_role_attachment,
        aws_vpc.cluster_vpc,
        aws_subnet.private_subnet_az1,
        aws_subnet.private_subnet_az2,
        aws_route_table.cluster_prv_rt,
        aws_route_table.cluster_pub_rt,
        aws_iam_role.eks_role,
        aws_iam_role.eks_nodes_role,
        aws_route_table_association.cluster_prv_sn_az1_association,
        aws_route_table_association.cluster_prv_sn_az2_association,
        aws_route_table_association.cluster_pub_sn_az1_association,
        aws_route_table_association.cluster_pub_sn_az2_association,
    ]

}