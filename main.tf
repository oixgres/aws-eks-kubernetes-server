provider "aws" {
    region = "us-east-1"
    # only if required
    access_key = "AKIAQ3EGULRWBMTGCEH2"
    secret_key = "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"
    # profile = "<aws assummed profile>"
}

module "network" {
    source = "./network"
}

module "resources" {
    source = "./resources"
    cluster_name = aws_eks_cluster.eks_cluster.name
    private_subnets = [module.network.private_az1_id, module.network.private_az2_id]
    public_subnets = [module.network.public_az1_id, module.network.public_az2_id]
    issuer = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

module "access" {
    source = "./access"
    cluster_name = aws_eks_cluster.eks_cluster.name
}

resource "aws_iam_role" "eks_cluster_role" {
    name = "eks_cluster_role"
    assume_role_policy = jsonencode(({
        Version = "2012-10-17"
        Statement = [{
            Action = [
                "sts:AssumeRole",
                "sts:TagSession"
            ]
            Effect = "Allow"
            Principal = {
                Service = "eks.amazonaws.com"
            }
        }]
    }))
}

resource "aws_iam_role_policy_attachment" "eks_cluster_role_attachment" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role = aws_iam_role.eks_cluster_role.name
}

resource "aws_eks_cluster" "eks_cluster" {
    name = "eks"
    role_arn = aws_iam_role.eks_cluster_role.arn
    version = "1.31"

    access_config {
        authentication_mode = "API"
        bootstrap_cluster_creator_admin_permissions = true
    }

    vpc_config {
        endpoint_private_access = false
        endpoint_public_access = true

        subnet_ids = [
            module.network.private_az1_id,
            module.network.private_az2_id,
            module.network.public_az1_id,
            module.network.public_az2_id
        ]
    }

    depends_on = [ 
        aws_iam_role_policy_attachment.eks_cluster_role_attachment
    ]
}