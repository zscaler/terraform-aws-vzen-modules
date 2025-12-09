################################################################################
# Define AssumeRole access for EC2
################################################################################
data "aws_iam_policy_document" "instance_assume_role_policy" {
  version = "2012-10-17"
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}


################################################################################
# Define AWS Managed SSM Session Manager Policy
################################################################################
data "aws_iam_policy_document" "vzen_session_manager_policy_document" {
  version = "2012-10-17"
  statement {
    sid    = "VZENPermitSSMSessionManager"
    effect = "Allow"
    actions = ["ssm:UpdateInstanceInformation",
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]
    resources = ["*"]
  }
}

# Create SSM Policy
resource "aws_iam_policy" "vzen_session_manager_policy" {
  count       = var.byo_iam == false ? var.iam_count : 0
  description = "Policy which permits VZENs to register to SSM Manager for Console Connect functionality"
  name        = "${var.name_prefix}-vzen-${count.index + 1}-ssm-${var.resource_tag}"
  policy      = data.aws_iam_policy_document.vzen_session_manager_policy_document.json
}

# Attach SSM Policy to IAM Role
resource "aws_iam_role_policy_attachment" "vzen_session_manager_attachment" {
  count      = var.byo_iam == false ? var.iam_count : 0
  policy_arn = aws_iam_policy.vzen_session_manager_policy[count.index].arn
  role       = aws_iam_role.vzen_node_iam_role[count.index].name
}

################################################################################
# Create VZEN IAM Role and Host/Instance Profile
################################################################################
resource "aws_iam_role" "vzen_node_iam_role" {
  count              = var.byo_iam == false ? var.iam_count : 0
  name               = var.iam_count > 1 ? "${var.name_prefix}-vzen-${count.index + 1}-node-iam-role-${var.resource_tag}" : "${var.name_prefix}-vzen_node_iam_role-${var.resource_tag}"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json

  tags = merge(var.global_tags)
}

# Assign VZEN IAM Role to Instance Profile for VZEN instance attachment
resource "aws_iam_instance_profile" "vzen_host_profile" {
  count = var.byo_iam ? 0 : var.iam_count
  name  = var.iam_count > 1 ? "${var.name_prefix}-vzen-${count.index + 1}-host-profile-${var.resource_tag}" : "${var.name_prefix}-vzen-host-profile-${var.resource_tag}"
  role  = aws_iam_role.vzen_node_iam_role[count.index].name

  tags = merge(var.global_tags)
}

# Or use existing IAM Instance Profile if specified in byo_iam
data "aws_iam_instance_profile" "vzen_host_profile_selected" {
  count = var.byo_iam ? length(var.byo_iam_instance_profile_id) : 0
  name  = element(var.byo_iam_instance_profile_id, count.index)
}
