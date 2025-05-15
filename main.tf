provider "aws" {
    region = "us-east-1"
    # only if required
    # access_key = "<your access key>"
    # secret_key = "<your secret access key"
    # profile = "<aws assummed profile>"
}

module "network" {
  
}

module "resources" {
  
}

module "access" {
  
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
    }

    vpc_config {
        subnet_ids = [

        ]
    }

    depends_on = [ aws_iam_role_po ]
}