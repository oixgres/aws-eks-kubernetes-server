variable "region" {
    default = "us-east-1"
    type = string
    description = "region where the cluster is located"
}

variable "cluster_name" {
    type = string
}

variable "cluster_role_arn" {
    type = string
}

variable "node_role_arn" {
    type = string
}

variable "ebs_csi_role_arn" {
    type = string
}

data "aws_eks_cluster" "eks" {
    name = module.cluster.name

    depends_on = [ module.cluster ]
}

data "aws_eks_cluster_auth" "eks" {
    name = module.cluster.name

    depends_on = [ module.cluster ]
}

provider "helm" {
    kubernetes = {
        host = data.aws_eks_cluster.eks.endpoint
        cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
        token = data.aws_eks_cluster_auth.eks.token
    }
}

module "cluster" {
    source = "../util/eks/cluster"
    name = var.cluster_name
    region = var.region
    subnets = module.network.subnets
    cluster_role_arn = var.cluster_role_arn
}

module "network" {
    source = "../util/eks/subnets"
    region = var.region
}

module "nodes" {
    source = "../util/eks/nodes"
    cluster_name = module.cluster.name
    node_role_arn = var.node_role_arn
    public_subnets = [module.network.subnets[0], module.network.subnets[1]]
    private_subnets = [module.network.subnets[2], module.network.subnets[3]]
}

module "addons" {
    source = "../util/eks/addons"
    cluster_name = module.cluster.name
    ebs_csi_role_arn = var.ebs_csi_role_arn
    vpc_id = module.network.vpc_id
    region = var.region

    depends_on = [ module.cluster, module.nodes, data.aws_eks_cluster.eks, data.aws_eks_cluster_auth.eks]
}