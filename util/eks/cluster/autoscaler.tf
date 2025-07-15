variable "region" {
    type = string
}

resource "aws_iam_role" "autoscaler" {
    name = "autoscaler-${var.region}"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Principal = {
                Federated = "${aws_iam_openid_connect_provider.this.arn}"
            }
            Action = "sts:AssumeRoleWithWebIdentity"
            Effect = "Allow"
            Condition = {
                StringEquals = {
                    "${replace(aws_iam_openid_connect_provider.this.url, "https://", "")}:sub" = "system:serviceaccount:kube-system:cluster-autoscaler"
                }
            }
        }]
    })
}

resource "aws_iam_policy" "autoscaler" {
    name = "autoscaler-${var.region}"
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Action = [
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeTags",
                "autoscaling:TerminateInstanceInAutoScalingGroup",
                "ec2:DescribeLaunchTemplateVersions"
            ]
            Effect = "Allow"
            Resource = "*"
        }]
    })
}

resource "aws_iam_role_policy_attachment" "autoscaler" {
    role = aws_iam_role.autoscaler.name
    policy_arn = aws_iam_policy.autoscaler.arn
}
