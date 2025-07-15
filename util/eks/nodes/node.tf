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

variable "node_role_arn" {
    type = string
}

resource "aws_eks_node_group" "private" {
    cluster_name = var.cluster_name
    node_group_name = "private"

    node_role_arn = var.node_role_arn
    subnet_ids = var.private_subnets

    capacity_type = "ON_DEMAND"
    instance_types = ["t3.large"]

    scaling_config {
        desired_size = 2
        max_size = 10
        min_size = 1
    }

    update_config {
        max_unavailable = 1
    }

    labels = {
        node = "kubenode01"
    }
}

resource "aws_eks_node_group" "public" {
    cluster_name = var.cluster_name
    node_group_name = "public"
    node_role_arn = var.node_role_arn

    subnet_ids = var.public_subnets

    capacity_type = "ON_DEMAND"
    instance_types = ["t3.large"]

    scaling_config {
        desired_size = 2
        max_size = 10
        min_size = 0
    }

    update_config {
        max_unavailable = 1
    }

    labels = {
        node = "kubenode01"
    }
}