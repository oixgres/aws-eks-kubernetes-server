variable "identifiers" {
    type = list(string)
    description = "list of services/resources that can assume the policy. Default pods.eks.amazonaws.com"
    default = [ "pods.eks.amazonaws.com" ]
}

variable "actions" {
    type = list(string)
    description = "list of allowed actions for the role. Default sts:AssumeRole, sts:TagSession"
    default = [ "sts:AssumeRole", "sts:TagSession" ]
}

data "aws_iam_policy_document" "this" {
    statement {
        effect = "Allow"

        principals {
            type = "Service"
            identifiers = var.identifiers
        }

        actions = var.actions
    }
}

output "json" {
    value = data.aws_iam_policy_document.this.json
}