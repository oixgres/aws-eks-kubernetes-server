variable "cluster_name" {
    type = string
}

data "aws_iam_policy_document" "this" {
    statement {
        effect = "Allow"

        principals {
            type = "Service"
            identifiers = ["pods.eks.amazonaws.com"]
        }

        actions = [
            "sts:AssumeRole",
            "sts:TagSession"
        ]
    }
}

resource "aws_iam_role" "this" {
    name = "${var.cluster_name}_aws_lbc"
    assume_role_policy = data.aws_iam_policy_document.this.json
}

resource "aws_iam_policy" "this" {
    policy = file("./load_balancing/lbc.json")
    name = "aws_load_balancer_controller"
}

resource "aws_iam_role_policy_attachment" "this" {
    policy_arn = aws_iam_policy.this.arn
    role = aws_iam_role.this.name
}

resource "aws_eks_pod_identity_association" "this" {
    cluster_name = var.cluster_name
    namespace = "kube-system"
    service_account = local.service_account
    role_arn = aws_iam_role.this.arn
}