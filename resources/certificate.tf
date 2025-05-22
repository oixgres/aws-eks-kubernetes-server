variable "issuer" {
    description = "issuer from the eks cluster 'aws_eks_cluster.<>.identity[0].oidc[0].issuer'"
}

data "tls_certificate" "eks_certificate" {
    url = var.issuer
}

resource "aws_iam_openid_connect_provider" "eks_openid_connector_provider" {
    client_id_list = ["sts:amazonaws.com"]
    thumbprint_list = [data.tls_certificate.eks_certificate.certificates[0].sha1_fingerprint]
    url = var.issuer
}