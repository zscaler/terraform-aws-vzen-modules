variable "vpc_id" {
  type        = string
  description = "VZEN VPC ID"
}

variable "vzen_service_ips" {
  type        = list(string)
  description = "VZEN forwarding service IPs"
  default     = []
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

variable "vzen_subnet_ids" {
  type        = list(string)
  description = "VZEN subnet IDs list"
}

variable "global_tags" {
  type        = map(string)
  description = "Populate any custom user defined tags from a map"
  default     = {}
}

variable "gwlb_name" {
  type        = string
  description = "GWLB resource and tag name"
  validation {
    condition     = length(var.gwlb_name) <= 32 && can(regex("^[A-Za-z0-9-]+$", var.gwlb_name)) #the AWS API itself will do some validation as well on this resource
    error_message = "Variable gwlb_name must be a max of 32 characters, contain only alphanumeric characters or hyphens, and must not begin or end with a hypen."
  }
}

variable "target_group_name" {
  type        = string
  description = "GWLB Target Group resource name"
  validation {
    condition     = length(var.target_group_name) <= 32 && can(regex("^[A-Za-z0-9-]+$", var.target_group_name)) #the AWS API itself will do some validation as well on this resource
    error_message = "Variable target_group_name must be a max of 32 characters, contain only alphanumeric characters or hyphens, and must not begin or end with a hypen."
  }
}

variable "rebalance_enabled" {
  type        = bool
  description = "Indicates how the GWLB handles existing flows when a target is deregistered or marked unhealthy. true means rebalance. false means no_rebalance. Default: true"
  default     = true
}
