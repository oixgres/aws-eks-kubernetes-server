variable "name" {
    description = "name of the cluster"
    type = string
}

variable "cluster_role_arn" {
    type = string
}

variable "subnets" {
    description = "list of subnet ids used for the eks cluster"
    type = list(string)
}

resource "aws_eks_cluster" "this" {
    name = var.name
    role_arn = var.cluster_role_arn
    version = "1.31"

    access_config {
        authentication_mode = "API"
        bootstrap_cluster_creator_admin_permissions = true
    }

    vpc_config {
        endpoint_private_access = false
        endpoint_public_access = true

        subnet_ids = var.subnets
    }
}

output "name" {
    value = aws_eks_cluster.this.name
}