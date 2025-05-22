data "aws_iam_policy_document" "eks_autoscaler_assume_role_policy" {
    statement {
        actions = ["sts:AssumeRoleWithWebIdentity"]
        effect = "Allow"

        condition {
            test = "StringEquals"
            variable = "${replace(aws_iam_openid_connect_provider.eks_openid_connector_provider.url, "https://", "")}:sub"
            values = ["system:serviceaccount:kube-system:cluster-autoscaler"]
        }

        principals {
            identifiers = [aws_iam_openid_connect_provider.eks_openid_connector_provider.arn]
            type = "Federated"
        }
    }
}

resource "aws_iam_role" "eks_autoscaler_role" {
    assume_role_policy = data.aws_iam_policy_document.eks_autoscaler_assume_role_policy.json
    name = "eks_cluster_autoscaler"
}

resource "aws_iam_policy" "eks_autoscaler_policy" {
    name = "eks_cluster_autoscaler"
    policy = jsonencode({
        Statement = [{
            Action = [
                "autoscaling:DescribeAutoScalingGrouops",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeTags",
                "autoscaling:TerminateInstanceInAutoScalingGroup",
                "ec2:DescribeLaunchTemplaceVersions"
            ]
            Effect = "Allow"
            Resource = "*"
        }]
        Version = "2012-10-17"
    })
}

resource "aws_iam_role_policy_attachment" "eks_autoscaler_attach" {
    role = aws_iam_role.eks_autoscaler_role.name
    policy_arn = aws_iam_policy.eks_autoscaler_policy.arn
}

output "eks_autoscaler_arn" {
    value = aws_iam_role.eks_autoscaler_role.arn
}