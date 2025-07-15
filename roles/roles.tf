variable "cluster_name" {
    type = string
}

module "eks_assume_role_policy" {
    source = "../util/iam/common"
    identifiers = ["eks.amazonaws.com"]
}

module "pods_assume_role_policy" {
    source = "../util/iam/common"
}

resource "aws_iam_role" "cluster" {
    name = "cluster_role"
    assume_role_policy = module.eks_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "cluster" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role = aws_iam_role.cluster.name
}

# node roles
resource "aws_iam_role" "node" {
    name = "node"

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

resource "aws_iam_role_policy_attachment" "worker_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "cni_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "ec2_cr_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role = aws_iam_role.node.name
}

output "cluster_arn" {
    value = aws_iam_role.cluster.arn
}

output "node_arn" {
    value = aws_iam_role.node.arn
}