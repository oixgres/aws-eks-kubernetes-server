resource "aws_eks_pod_identity_association" "ebs_csi_driver" {
    cluster_name = var.cluster_name
    namespace = "kube-system"
    service_account = "ebs-csi-controller-sa"
    role_arn = aws_iam_role.ebs_csi_driver_role.arn
}

resource "aws_eks_addon" "pod_identity" {
    cluster_name = var.cluster_name
    addon_name = "eks-pod-identity-agent"
    addon_version = "v1.2.0-eksbuild.1"
}

resource "aws_eks_addon" "ebs_csi_driver" {
    cluster_name = var.cluster_name
    addon_name = "aws-ebs-csi-driver"
    addon_version = "v1.30.0-eksbuild.1"
    service_account_role_arn = aws_iam_role.ebs_csi_driver_role.arn

    depends_on = [ aws_eks_node_group.public_node_group ]
}
