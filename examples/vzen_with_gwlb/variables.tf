variable "aws_region" {
  type        = string
  description = "The AWS region."
  default     = "us-west-2"
}

variable "name_prefix" {
  type        = string
  description = "The name prefix for all your resources"
  default     = "zsvzen"
  validation {
    condition     = length(var.name_prefix) <= 12
    error_message = "Variable name_prefix must be 12 or less characters."
  }
}

variable "vpc_cidr" {
  type        = string
  description = "VPC IP CIDR Range."
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
  description = "Default number of subnets to create based on availability zone"
  default     = 1
  validation {
    condition = (
      (var.az_count >= 1 && var.az_count <= 3)
    )
    error_message = "Input az_count must be set to a single value between 1 and 3. Note* some regions have greater than 3 AZs. Please modify az_count validation in variables.tf if you are utilizing more than 3 AZs in a region that supports it. https://aws.amazon.com/about-aws/global-infrastructure/regions_az/."
  }
}

variable "owner_tag" {
  type        = string
  description = "populate custom owner tag attribute"
  default     = "zsvzen-admin"
}

variable "tls_key_algorithm" {
  type        = string
  description = "algorithm for tls_private_key resource"
  default     = "RSA"
}

variable "vzen_mgmt_sg_allowed_ssh_ips" {
  type        = list(string)
  description = "CIDR blocks of trusted networks for vzen host ssh access"
  default     = ["10.1.0.0/16"]
}

variable "vzen_count" {
  type        = number
  description = "Number of VZENs to create. 2 VZENs by default in case of vzen_with_gwlb deployment type."
  default     = 2
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

variable "reuse_security_group" {
  type        = bool
  description = "Specifies whether the SG module should create 1:1 security groups per instance or 1 security group for all instances"
  default     = false
}

variable "reuse_iam" {
  type        = bool
  description = "Specifies whether the SG module should create 1:1 IAM per instance or 1 IAM for all instances"
  default     = false
}

variable "set_your_own_ami_id" {
  type        = string
  description = "AMI ID to be used for deploying VZEN appliances. Ideally all VMs should be on the same AMI ID as templates always pull the latest from AWS Marketplace. This variable is provided if a customer desires to override/retain an old ami for existing deployments rather than upgrading and forcing a replacement."
  default     = ""
}

variable "mgmt_ssh_enabled" {
  type        = bool
  description = "Default is true which creates an ingress rule permitting SSH traffic from the local VPC to the VZEN management interface. If false, the rule is not created. Value ignored if not creating a security group"
  default     = true
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

variable "all_ports_egress_enabled" {
  type        = bool
  default     = true
  description = "Default is true which creates an egress rule permitting the VZEN service interface to forward direct traffic on all ports and protocols. If false, the rule is not created. Value ignored if not creating a security group"
}

variable "ebs_volume_type" {
  type        = string
  description = "(Optional) Type of volume. Valid values include standard, gp2, gp3, io1, io2, sc1, or st1. Defaults to gp3"
  default     = "gp3"
}

variable "brownfield_deployment" {
  type        = bool
  description = "If you want to deploy all resources in an AWS Infra which already has VZEN Deployments"
  default     = false
}

variable "byo_vpc_id" {
  type        = string
  description = "User provided existing AWS VPC name. This must be populated if brownfield_deployment variable is true"
  default     = ""
}

variable "byo_igw_id" {
  type        = string
  description = "User provided existing AWS Internet Gateway name. This must be populated if brownfield_deploymentvariable is true"
  default     = ""
}

variable "byo_subnet_ids" {
  type        = list(string)
  description = "User provided existing AWS subnet id(s). This must be populated if brownfield_deployment variable is true"
  default     = null
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

variable "set_your_own_tag" {
  type        = map(string)
  description = "Set your own Tags. It must be of 'dict' type, else by default an empty dictionary"
  default     = {}
}

variable "http_probe_port" {
  type        = number
  description = "Port number for VZEN cloud init to enable listener port for HTTP probe from GWLB Target Group"
  default     = 50000
  validation {
    condition = (
      tonumber(var.http_probe_port) == 80 ||
      (tonumber(var.http_probe_port) >= 1024 && tonumber(var.http_probe_port) <= 65535)
    )
    error_message = "Input http_probe_port must be set to a single value of 80 or any number between 1024-65535."
  }
}

variable "health_check_interval" {
  type        = number
  description = "Interval for GWLB target group health check probing, in seconds, of VZEN targets. Minimum 5 and maximum 300 seconds"
  default     = 10
}

variable "healthy_threshold" {
  type        = number
  description = "The number of successful health checks required before an unhealthy target becomes healthy. Minimum 2 and maximum 10"
  default     = 5
}

variable "unhealthy_threshold" {
  type        = number
  description = "The number of unsuccessful health checks required before an healthy target becomes unhealthy. Minimum 2 and maximum 10"
  default     = 2
}

variable "cross_zone_lb_enabled" {
  type        = bool
  description = "Determines whether GWLB cross zone load balancing should be enabled or not"
  default     = false
}

variable "rebalance_enabled" {
  type        = bool
  description = "Indicates how the GWLB handles existing flows when a target is deregistered or marked unhealthy. true means rebalance. false means no_rebalance. Default: true"
  default     = true
}

variable "acceptance_required" {
  type        = bool
  description = "Whether to require manual acceptance of any VPC Endpoint registration attempts to the Endpoint Service or not. Default is false"
  default     = false
}

variable "allowed_principals" {
  type        = list(string)
  description = "List of AWS Principal ARNs who are allowed access to the GWLB Endpoint Service. E.g. [\"arn:aws:iam::1234567890:root\"]`. See https://docs.aws.amazon.com/vpc/latest/privatelink/configure-endpoint-service.html#accept-reject-connection-requests"
  default     = []
}
