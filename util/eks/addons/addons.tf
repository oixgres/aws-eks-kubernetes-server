variable "cluster_name" {
    type = string
}

variable "ebs_csi_role_arn" {
    type = string
}

resource "aws_eks_pod_identity_association" "ebs_csi_driver" {
    cluster_name = var.cluster_name
    namespace = "kube-system"
    service_account = "ebs-csi-controller-sa"
    role_arn = var.ebs_csi_role_arn
}

resource "aws_eks_addon" "ebs_csi_driver" {
    cluster_name = var.cluster_name
    addon_name = "aws-ebs-csi-driver"
    addon_version = "v1.30.0-eksbuild.1"
    service_account_role_arn = var.ebs_csi_role_arn
}

resource "aws_eks_addon" "pod_identity" {
    cluster_name = var.cluster_name
    addon_name = "eks-pod-identity-agent"
    addon_version = "v1.2.0-eksbuild.1"
}
