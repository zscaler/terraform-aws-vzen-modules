################################################################################
# Pull in VPC info
################################################################################
data "aws_vpc" "selected" {
  id = var.vpc_id
}


################################################################################
# Create Security Group and Rules for VZEN Management Interfaces
################################################################################
resource "aws_security_group" "vzen_mgmt_sg" {
  count       = var.byo_security_group == false ? var.sg_count : 0
  name        = var.sg_count > 1 ? "${var.name_prefix}-vzen-${count.index + 1}-mgmt-sg-${var.resource_tag}" : "${var.name_prefix}-vzen-mgmt-sg-${var.resource_tag}"
  description = "Security group for VZEN management interface"
  vpc_id      = var.vpc_id

  tags = merge(var.global_tags,
    { Name = "${var.name_prefix}-vzen-mgmt-sg-${count.index + 1}-${var.resource_tag}" }
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "ssh" {
  count       = var.byo_security_group == false ? var.sg_count : 0
  protocol          = "TCP"
  from_port         = 22
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = var.vzen_mgmt_sg_allowed_ssh_ips
  security_group_id = aws_security_group.vzen_mgmt_sg[count.index].id
  description       = "Recommended: SSH to VZEN management"
}

#Default required egress connectivity
resource "aws_vpc_security_group_egress_rule" "egress_vzen_management" {
  count             = var.byo_security_group == false ? var.sg_count : 0
  description       = "Required: VZEN outbound ALL"
  security_group_id = aws_security_group.vzen_mgmt_sg[count.index].id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# Or use existing Management Security Group ID
data "aws_security_group" "vzen_mgmt_sg_selected" {
  count = var.byo_security_group ? length(var.byo_mgmt_security_group_id) : 0
  id    = element(var.byo_mgmt_security_group_id, count.index)
}


################################################################################
# Create Security Group and Rules for VZEN Service Interfaces
################################################################################
resource "aws_security_group" "vzen_service_sg" {
  count       = var.byo_security_group == false ? var.sg_count : 0
  name        = var.sg_count > 1 ? "${var.name_prefix}-vzen-${count.index + 1}-svc-sg-${var.resource_tag}" : "${var.name_prefix}-vzen-svc-sg-${var.resource_tag}"
  description = "Security group for VZEN service interfaces"
  vpc_id      = var.vpc_id

  tags = merge(var.global_tags,
    { Name = "${var.name_prefix}-vzen-svc-sg-${count.index + 1}-${var.resource_tag}" }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# Or use existing Service Security Group ID
data "aws_security_group" "vzen_service_sg_selected" {
  count = var.byo_security_group ? length(var.byo_service_security_group_id) : 0
  id    = element(var.byo_service_security_group_id, count.index)
}

#Default required egress connectivity
resource "aws_vpc_security_group_egress_rule" "egress_vzen_service" {
  count             = var.byo_security_group == false ? var.sg_count : 0
  description       = "Required: VZEN outbound ALL"
  security_group_id = aws_security_group.vzen_service_sg[count.index].id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}


#Default required for non-GWLB deployments
resource "aws_vpc_security_group_ingress_rule" "ingress_vzen_service_all" {
  count             = var.byo_security_group == false ? var.sg_count : 0
  description       = "Optional: Permit All Intra-VPC Traffic / Ensure VZEN Service Interfaces are able to communicate with each other freely"
  security_group_id = aws_security_group.vzen_service_sg[count.index].id
  cidr_ipv4         = data.aws_vpc.selected.cidr_block
  ip_protocol       = "-1"
}