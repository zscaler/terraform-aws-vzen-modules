variable "name_prefix" {
  type        = string
  description = "A prefix to associate to all the network module resources"
  default     = null
}

variable "resource_tag" {
  type        = string
  description = "A tag to associate to all the network module resources"
  default     = null
}

variable "global_tags" {
  type        = map(string)
  description = "Populate any custom user defined tags from a map"
  default     = {}
}

variable "vpc_cidr" {
  type        = string
  description = "VPC IP CIDR Range"
  default     = "10.1.0.0/16"
}

variable "byo_new_subnet_cidr" {
  type        = string
  description = "In brownfield deployments, where new public subnets for VZENs need to be created, provide the CIDR block values for the subnets corresponding to your byo_vpc_id."
  default     = null
  validation {
    condition     = var.byo_new_subnet_cidr == null || can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]{1,2}$", var.byo_new_subnet_cidr))
    error_message = "The value of byo_new_subnet_cidr must be either null or a valid CIDR block (e.g., 10.1.101.0/24)."
  }
}

variable "az_count" {
  type        = number
  description = "Default number of subnets to create based on availability zone input"
  default     = 1
  validation {
    condition = (
      (var.az_count >= 1 && var.az_count <= 3)
    )
    error_message = "Input az_count must be set to a single value between 1 and 3. Note* some regions have greater than 3 AZs. Please modify az_count validation in variables.tf if you are utilizing more than 3 AZs in a region that supports it. https://aws.amazon.com/about-aws/global-infrastructure/regions_az/."
  }
}

variable "base_only" {
  type        = bool
  default     = false
  description = "Default is false. Only applicable for base deployment type resulting in workload and vzen hosts, but noVZEN resources. Setting this to true will point workload route able to nat_gateway_id"
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

# BYO (Bring-your-own) variables list

variable "brownfield_deployment" {
  type        = bool
  description = "If you want to deploy all resources in an AWS Infra which already has VZEN Deployments"
  default     = false
}

variable "byo_vpc_id" {
  type        = string
  description = "User provided existing AWS VPC ID"
  default     = null
}

variable "byo_subnet_ids" {
  type        = list(string)
  description = "User provided existing AWS subnet id(s). This must be populated if brownfield_deployment variable is true"
  default     = null
}

variable "byo_igw_id" {
  type        = string
  description = "User provided existing AWS Internet Gateway ID"
  default     = null
}

variable "gwlb_enabled" {
  type        = bool
  default     = true
  description = "true inside gwlb example, false for standalone"
}

variable "gwlb_endpoint_ids" {
  type        = list(string)
  default     = [""]
  description = "List of GWLB Endpoint IDs for use in private workloadwith GWLB deployments. Utilized if var.gwlb_enabled is set to true"
}
