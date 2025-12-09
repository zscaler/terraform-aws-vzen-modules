variable "name_prefix" {
  type        = string
  description = "A prefix to associate to all the VZEN Security Group module resources"
  default     = null
}

variable "resource_tag" {
  type        = string
  description = "A tag to associate to all the VZEN Security Group module resources"
  default     = null
}

variable "global_tags" {
  type        = map(string)
  description = "Populate any custom user defined tags from a map"
  default     = {}
}

variable "vzen_mgmt_sg_allowed_ssh_ips" {
  type        = list(string)
  description = "CIDR blocks of trusted networks for vzen host ssh access"
  default     = ["10.1.0.0/16"]
}

variable "vpc_id" {
  type        = string
  description = "VZEN VPC ID"
}

variable "sg_count" {
  type        = number
  description = "Default number of security groups to create"
  default     = 1
}

variable "byo_security_group" {
  type        = bool
  description = "Bring your own Security Group for VZEN. Setting this variable to true will effectively instruct this module to not create any resources and only reference data resources from values provided in byo_mgmt_security_group_id and byo_service_security_group_id"
  default     = false
}

variable "byo_mgmt_security_group_id" {
  type        = list(string)
  description = "Management Security Group ID for VZEN association"
  default     = null
}

variable "byo_service_security_group_id" {
  type        = list(string)
  description = "Service Security Group ID for VZEN association"
  default     = null
}

variable "mgmt_ssh_enabled" {
  type        = bool
  description = "Default is true which creates an ingress rule permitting SSH traffic from the Deployment VM to the VZEN management interface. If false, the rule is not created."
  default     = true
}

variable "all_ports_egress_enabled" {
  type        = bool
  default     = true
  description = "Default is true which creates an egress rule permitting the VZEN service interface to forward direct traffic on all ports and protocols."
}
