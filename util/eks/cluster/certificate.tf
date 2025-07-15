locals {
    issuer_url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

data "tls_certificate" "this" {
    url = local.issuer_url
}

resource "aws_iam_openid_connect_provider" "this" {
    client_id_list = ["sts:amazonaws.com"]
    thumbprint_list = [data.tls_certificate.this.certificates[0].sha1_fingerprint]
    url = local.issuer_url
}