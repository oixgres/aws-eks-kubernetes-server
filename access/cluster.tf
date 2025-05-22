variable "cluster_name" {
    description = "name of the eks cluster"
}

data "aws_caller_identity" "current" {}

resource "aws_eks_access_entry" "cloud_user" {
    cluster_name = var.cluster_name
    principal_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/cloud_user"
    type = "STANDARD"
}

resource "aws_eks_access_policy_association" "cloud_user_eks_admin" {
    cluster_name = var.cluster_name
    policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
    principal_arn = aws_eks_access_entry.cloud_user.principal_arn

    access_scope {
        type = "cluster"
    }
}

resource "aws_eks_access_policy_association" "cloud_user_cluster_admin" {
    cluster_name = var.cluster_name
    policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
    principal_arn = aws_eks_access_entry.cloud_user.principal_arn

    access_scope {
        type = "cluster"
    }
}