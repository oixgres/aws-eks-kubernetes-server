locals {
    service_account = "aws-load-balancer-controller"
    helm_name = "aws-load-balancer-controller"
}

variable "vpc_id" {
    type = string
    description = "id of the vpc used for the eks cluster"
}

resource "helm_release" "load_balancer_controller" {
    name = local.helm_name
    repository = "https://aws.github.io/eks-charts"
    chart = local.helm_name
    namespace = "kube-system"
    version = "1.8.1"

    set = [
        {
            name = "clusterName"
            value = var.cluster_name
        },
        {
            name = "serviceAccount.name"
            value = local.service_account
        },
        {
            name = "vpcId"
            value = var.vpc_id
        },
        {
            name = "awsRegion"
            value = "us-east-1"
        }
    ]
}