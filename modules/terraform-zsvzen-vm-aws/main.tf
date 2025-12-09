

################################################################################
# Create VZEN VM
################################################################################
resource "aws_instance" "vzen_vm" {
  count                = var.vzen_count
  ami                  = var.ami_id
  instance_type        = var.vzen_vm_instance_type
  iam_instance_profile = element(var.iam_instance_profile, count.index)
  key_name             = var.instance_key
  ebs_optimized        = true

  metadata_options {
    http_endpoint          = "enabled"
    http_tokens            = "required"
  }

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.vzen_vm_nic_index_0[count.index].id
  }

  network_interface {
    device_index         = 1
    network_interface_id = aws_network_interface.vzen_vm_nic_index_1[count.index].id
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 501
    delete_on_termination = true
    iops                  = 3000

    tags = merge(var.global_tags,
      { Name = "${var.name_prefix}-vzen-vm-${count.index + 1}-ebs-${var.resource_tag}" }
    )
  }

  tags = merge(var.global_tags,
    { Name = "${var.name_prefix}-vzen-vm-${count.index + 1}-${var.resource_tag}" }
  )

  depends_on = [
    aws_network_interface.vzen_vm_nic_index_0,
    aws_network_interface.vzen_vm_nic_index_1
  ]
}

# wait for all VZEN Instances to be Created
resource "null_resource" "wait_for_vzens" {
  count = var.vzen_count

  triggers = {
    instance_id = aws_instance.vzen_vm[count.index].id
  }
}


################################################################################
# Create VZEN Management Interface
################################################################################
resource "aws_network_interface" "vzen_vm_nic_index_0" {
  count             = var.vzen_count
  description       = "vzen management interface"
  subnet_id         = element(var.mgmt_subnet_id, count.index)
  security_groups   = concat([element(var.mgmt_security_group_id, count.index)], var.additional_mgmt_security_group_ids)

  tags = merge(var.global_tags,
  { Name = "${var.name_prefix}-vm-${count.index + 1}-${var.resource_tag}-Mgmt-IF" })
}

# wait for all Management NICs to be made
resource "null_resource" "wait_for_management_nics" {
  count = var.vzen_count

  triggers = {
    nic_id = aws_network_interface.vzen_vm_nic_index_0[count.index].id
  }
}

# Its ELastic IP
resource "aws_eip" "eip_management_interface" {
  count      = var.vzen_count

  network_interface = aws_network_interface.vzen_vm_nic_index_0[count.index].id

  # depends_on = [aws_network_interface.vzen_vm_nic_index_0[count.index].id]

  tags = merge(var.global_tags,
    { Name = "${var.name_prefix}-eip-management-interface-az${count.index + 1}-${var.resource_tag}" }
  )

  depends_on = [null_resource.wait_for_management_nics, null_resource.wait_for_vzens]
}

################################################################################
# Create VZEN Service Interface
################################################################################
resource "aws_network_interface" "vzen_vm_nic_index_1" {
  count             = var.vzen_count
  description       = "vzen service interface"
  subnet_id         = element(var.mgmt_subnet_id, count.index)
  security_groups   = [element(var.service_security_group_id, count.index)]

  tags = merge(var.global_tags,
  { Name = "${var.name_prefix}-vm-${count.index + 1}-${var.resource_tag}-Service-IF" })
}

# wait for all Service NICs to be made
resource "null_resource" "wait_for_service_nics" {
  count = var.vzen_count

  triggers = {
    nic_id = aws_network_interface.vzen_vm_nic_index_1[count.index].id
  }
}
# Its ELastic IP
resource "aws_eip" "eip_service_interface" {
  count      = var.vzen_count

  network_interface = aws_network_interface.vzen_vm_nic_index_1[count.index].id

  tags = merge(var.global_tags,
    { Name = "${var.name_prefix}-eip-service-interface-az${count.index + 1}-${var.resource_tag}" }
  )

  depends_on = [null_resource.wait_for_service_nics, null_resource.wait_for_vzens]
}
