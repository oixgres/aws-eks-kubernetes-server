provider "aws" {
    alias = "us"
    region = "us-east-1"
}

provider "aws" {
    alias = "us2"
    region = "us-west-2"
}

locals {
    cluster_name = "eks"
}

module "roles" {
    source = "./roles"
    cluster_name = local.cluster_name

    providers = {
        aws = aws.us
    }
}

module "eks-na1" {
    source = "./clusters"
    region = "us-east-1"

    cluster_name = local.cluster_name

    cluster_role_arn = module.roles.cluster_arn
    node_role_arn = module.roles.node_arn
    ebs_csi_role_arn = module.roles.ebs_csi_driver_arn

    providers = {
        aws = aws.us
    }
}

module "eks-na2" {
    source = "./clusters"
    region = "us-west-2"

    cluster_name = local.cluster_name

    cluster_role_arn = module.roles.cluster_arn
    node_role_arn = module.roles.node_arn
    ebs_csi_role_arn = module.roles.ebs_csi_driver_arn

    providers = {
        aws = aws.us2
    }
}
