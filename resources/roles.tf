resource "aws_iam_role" "node_role" {
    name = "eks_node_group_role"

    assume_role_policy = jsonencode({
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = "ec2.amazonaws.com"
            }
        }]
        Version = "2012-10-17"
    })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_attach" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role = aws_iam_role.node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_worker_cni_attach" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role = aws_iam_role.node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_ec2_container_attach" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role = aws_iam_role.node_role.name
}

data "aws_iam_policy_document" "ebs_csi_driver_doc" {
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

resource "aws_iam_role" "ebs_csi_driver_role" {
    name = "${var.cluster_name}_ebs_csi_driver_role"
    assume_role_policy = data.aws_iam_policy_document.ebs_csi_driver_doc.json
}

resource "aws_iam_role_policy_attachment" "ebs_csi_driver_attach" {
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
    role = aws_iam_role.ebs_csi_driver_role.name
}

resource "aws_iam_policy" "ebs_csi_driver_enc" {
    name = "${var.cluster_name}_ebs_csi_driver_enc"

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

resource "aws_iam_role_policy_attachment" "ebs_csi_driver_enc_attach" {
    policy_arn = aws_iam_policy.ebs_csi_driver_enc.arn
    role = aws_iam_role.ebs_csi_driver_role.name
}
