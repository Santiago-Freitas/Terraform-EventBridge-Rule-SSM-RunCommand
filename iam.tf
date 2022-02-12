data "aws_caller_identity" "current" {}
locals {
  account_id = data.aws_caller_identity.current.account_id
}

data "aws_iam_policy_document" "ssm_lifecycle" {
  statement {
    effect  = "Allow"
    actions = ["ssm:SendCommand"]
    resources = [
      "arn:aws:ec2:${var.aws_region}:${local.account_id}:instance/*",
      "arn:aws:ssm:${var.aws_region}:*:document/AWS-RunShellScript"
    ]
  }
}

data "aws_iam_policy_document" "ssm_lifecycle_trust" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "run_command_role" {
  name               = "run_command_role"
  assume_role_policy = data.aws_iam_policy_document.ssm_lifecycle_trust.json
}

resource "aws_iam_policy" "run_command_policy" {
  name   = "run_command_policy"
  policy = data.aws_iam_policy_document.ssm_lifecycle.json
}

resource "aws_iam_role_policy_attachment" "run_command_policy_attachment" {
  policy_arn = aws_iam_policy.run_command_policy.arn
  role       = aws_iam_role.run_command_role.name
}