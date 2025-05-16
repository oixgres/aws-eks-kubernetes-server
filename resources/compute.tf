variable "cluster_name" {
    type = string
    description = "name of the cluster"
}

variable "private_subnets" {
    type = list(string)
    description = "private subnet id list"
}

variable "public_subnets" {
    type = list(string)
    description = "public subnet id list"
}

resource "aws_eks_node_group" "private_node_group" {
    cluster_name = var.cluster_name
    node_group_name = "private_node_group"
    node_role_arn = aws_iam_role.node_role.arn

    subnet_ids = var.private_subnets

    capacity_type = "ON_DEMAND"
    instance_types = ["t2.medium"]

    scaling_config {
        desired_size = 2
        max_size = 10
        min_size = 1
    }

    update_config {
        max_unavailable = 1
    }

    labels = {
        node = "kubenode02"
    }

    depends_on = [
        aws_iam_role_policy_attachment.eks_ec2_container_attach,
        aws_iam_role_policy_attachment.eks_worker_cni_attach,
        aws_iam_role_policy_attachment.eks_worker_node_attach
    ]
}

resource "aws_eks_node_group" "public_node_group" {
    cluster_name = var.cluster_name
    node_group_name = "public_node_group"
    node_role_arn = aws_iam_role.node_role.arn

    subnet_ids = var.public_subnets

    capacity_type = "ON_DEMAND"
    instance_types = ["t2.medium"]

    scaling_config {
        desired_size = 2
        max_size = 10
        min_size = 0
    }

    update_config {
        max_unavailable = 1
    }

    labels = {
        node = "kubenode03"
    }

    depends_on = [
        aws_iam_role_policy_attachment.eks_ec2_container_attach,
        aws_iam_role_policy_attachment.eks_worker_cni_attach,
        aws_iam_role_policy_attachment.eks_worker_node_attach
    ]
}

