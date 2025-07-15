resource "aws_iam_role" "ebs_csi_driver" {
    name = "ebs_csi_driver"
    assume_role_policy = module.pods_assume_role_policy.json
}

resource "aws_iam_policy" "ebs_csi_driver_enc" {
    name = "ebs_csi_driver_enc"

    policy = jsonencode({
        Version = "2012-10-17"

        Statement = [{
            Effect = "Allow"
            Action = [
                "kms:Decrypt",
                "kms:GenerateDataKeyWithoutPlainText",
                "kms:CreateGrant"
            ],
            Resource = "*"
        }]
    })
}

resource "aws_iam_role_policy_attachment" "ebs_csi_driver_policy" {
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
    role = aws_iam_role.ebs_csi_driver.name
}

resource "aws_iam_role_policy_attachment" "ebs_csi_driver_enc" {
    policy_arn = aws_iam_policy.ebs_csi_driver_enc.arn
    role = aws_iam_role.ebs_csi_driver.name
}

output "ebs_csi_driver_arn" {
    value = aws_iam_role.ebs_csi_driver.arn
}