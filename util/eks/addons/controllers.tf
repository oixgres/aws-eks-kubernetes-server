variable "vpc_id" {
    type = string
}

variable "region" {
    type = string
}

module "pods_assume_role_policy" {
    source = "../../iam/common"
}

resource "aws_iam_role" "load_balancer_controller" {
    name = "eks-load-balancer-controller-${var.region}"
    assume_role_policy = module.pods_assume_role_policy.json
}

resource "aws_iam_policy" "load_balancer_controller" {
    policy = file("./roles/lbc.json")
    name = "eks-load-balancer-controller-${var.region}"
}

resource "aws_iam_role_policy_attachment" "load_balancer_controller" {
    policy_arn = aws_iam_policy.load_balancer_controller.arn
    role = aws_iam_role.load_balancer_controller.name
}

resource "aws_eks_pod_identity_association" "load_balancer_controller" {
    cluster_name = var.cluster_name
    namespace = "kube-system"
    service_account = "eks-load-balancer-controller-${var.region}"
    role_arn = aws_iam_role.load_balancer_controller.arn
}

resource "helm_release" "load_balancer_controller" {
    name = "eks-load-balancer-controller-${var.region}"
    repository = "https://aws.github.io/eks-charts"
    chart = "aws-load-balancer-controller"
    namespace = "kube-system"
    version = "1.8.1"

    set = [
        {
            name = "clusterName"
            value = var.cluster_name
        },
        {
            name = "serviceAccount.name"
            value = "eks-load-balancer-controller-${var.region}"
        },
        {
            name = "vpcId"
            value = var.vpc_id
        },
        {
            name = "awsRegion"
            value = var.region
        }
    ]

    depends_on = [ aws_eks_addon.pod_identity ]
}
