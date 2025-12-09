variable "name_prefix" {
  type        = string
  description = "A prefix to associate to all the VZEN module resources"
  default     = null
}

variable "resource_tag" {
  type        = string
  description = "A tag to associate to all the VZEN module resources"
  default     = null
}

variable "global_tags" {
  type        = map(string)
  description = "Populate any custom user defined tags from a map"
  default     = {}
}

variable "mgmt_subnet_id" {
  type        = list(string)
  description = "VZEN EC2 Instance management subnet id"
}

variable "service_subnet_id" {
  type        = list(string)
  description = "VZEN EC2 Instance service subnet id"
}

variable "instance_key" {
  type        = string
  description = "SSH Key for instances"
}

variable "vzen_vm_instance_type" {
  type        = string
  description = "VZEN Instance Type"
  default     = "m5.2xlarge"
  validation {
    condition = (
      var.vzen_vm_instance_type == "m5.2xlarge" ||
      var.vzen_vm_instance_type == "r5.2xlarge"
    )
    error_message = "Input vzen_vm_instance_type must be set to an approved vm instance type."
  }
}

variable "vzen_count" {
  type        = number
  description = "Default number of VZEN appliances to create"
  default     = 2
}

variable "mgmt_security_group_id" {
  type        = list(string)
  description = "VZEN EC2 Instance management security group id"
}

variable "additional_mgmt_security_group_ids" {
  type        = list(string)
  description = "Optional additional VZEN EC2 Instance management security group ids to be attached to the to the management interface"
  default     = []
}

variable "service_security_group_id" {
  type        = list(string)
  description = "VZEN EC2 Instance service security group id"
}

variable "iam_instance_profile" {
  type        = list(string)
  description = "IAM instance profile ID assigned to VZEN"
}

variable "ami_id" {
  type        = string
  description = "AMI ID(s) to be used for deploying VZEN appliances. Ideally all VMs should be on the same AMI ID as templates always pull the latest from AWS Marketplace."
}

variable "hostname_type" {
  type        = string
  description = "Type of hostname for Amazon EC2 instances"
  default     = "resource-name"

  validation {
    condition = (
      var.hostname_type == "resource-name" ||
      var.hostname_type == "ip-name"
    )
    error_message = "Input hostname_type must be set to either resource-name or ip-name."
  }
}
