################################################################################
# Generate a unique random string for resource name assignment and key pair
################################################################################
resource "random_string" "suffix" {
  length  = 8
  upper   = false
  special = false
}


################################################################################
# Custom input validation checks
################################################################################

check "byo_vpc_id_validation_1" {
  assert {
    condition     = var.brownfield_deployment == false ? (var.byo_vpc_id == null || var.byo_vpc_id == "") : true
    error_message = "When 'brownfield_deployment' is false, 'byo_vpc_id' must be null or an empty string."
  }
}

check "byo_vpc_id_validation_2" {
  assert {
    condition     = !(var.byo_igw_id != "" && var.byo_vpc_id == "")
    error_message = "If you are providing an Internet Gateway, then you must also provide its VPC."
  }
}

check "byo_igw_id_validation_1" {
  assert {
    condition     = var.brownfield_deployment == false ? (var.byo_igw_id == null || var.byo_igw_id == "") : true
    error_message = "When 'brownfield_deployment' is false, 'byo_igw_id' must be null or an empty string."
  }
}

check "byo_igw_id_validation_2" {
  assert {
    condition     = !(var.byo_vpc_id != "" && var.byo_igw_id == "")
    error_message = "If you are providing a VPC, then you must also provide its attached Internet Gateway."
  }
}

check "byo_subnet_ids_validation_1" {
  assert {
    condition     = var.brownfield_deployment == false ? (var.byo_subnet_ids == null || var.byo_subnet_ids == "") : true
    error_message = "When 'brownfield_deployment' is false, 'byo_subnet_ids' must be null or an empty string."
  }
}

check "byo_subnet_ids_validation_2" {
  assert {
    condition     = var.byo_vpc_id == "" ? (var.byo_subnet_ids == null || var.byo_subnet_ids == "") : true
    error_message = "When 'byo_vpc_id' is not provided, 'byo_subnet_ids' must not be set."
  }
}

check "byo_subnet_ids_validation_3" {
  assert {
    condition     = var.byo_igw_id == "" ? (var.byo_subnet_ids == null || var.byo_subnet_ids == "") : true
    error_message = "When 'byo_igw_id' is not provided, 'byo_subnet_ids' must not be set."
  }
}

check "byo_new_subnet_cidr_validation_1" {
  assert {
    condition     = var.brownfield_deployment == false ? (var.byo_new_subnet_cidr == null || var.byo_new_subnet_cidr == "") : true
    error_message = "When 'brownfield_deployment' is false, 'byo_new_subnet_cidr' must be null or an empty string."
  }
}

check "byo_new_subnet_cidr_validation_2" {
  assert {
    condition     = var.byo_vpc_id == "" ? (var.byo_new_subnet_cidr == null || var.byo_new_subnet_cidr == "") : true
    error_message = "When 'byo_vpc_id' is not provided, 'byo_new_subnet_cidr' must not be set."
  }
}

check "byo_new_subnet_cidr_validation_3" {
  assert {
    condition     = var.byo_igw_id == "" ? (var.byo_new_subnet_cidr == null || var.byo_new_subnet_cidr == "") : true
    error_message = "When 'byo_igw_id' is not provided, 'byo_new_subnet_cidr' must not be set."
  }
}

check "byo_new_subnet_cidr_validation_4" {
  assert {
    condition     = var.byo_subnet_ids != null ? (var.byo_new_subnet_cidr == null || var.byo_new_subnet_cidr == "") : true
    error_message = "When 'byo_subnet_ids' is provided, 'byo_new_subnet_cidr' must not be set."
  }
}

check "byo_new_subnet_cidr_validation_5" {
  assert {
    condition     = var.brownfield_deployment || var.byo_new_subnet_cidr == null
    error_message = "The variable 'byo_new_subnet_cidr' can only be set if 'brownfield_deployment' is true."
  }
}

check "byo_mgmt_security_group_id_validation" {
  assert {
    condition     = var.brownfield_deployment || var.byo_mgmt_security_group_id == null
    error_message = "The variable 'byo_mgmt_security_group_id' can only be set if 'brownfield_deployment' is true."
  }
}

check "byo_service_security_group_id_validation" {
  assert {
    condition     = var.brownfield_deployment || var.byo_service_security_group_id == null
    error_message = "The variable 'byo_service_security_group_id' can only be set if 'brownfield_deployment' is true."
  }
}

################################################################################
# Map default tags with values to be assigned to all tagged resources
################################################################################
locals {
  global_tags       = var.set_your_own_tag
  key_suffix        = "${var.name_prefix}-key-${random_string.suffix.result}"
  key_name          = local.key_suffix
  file_name         = "./${local.key_suffix}.pem"
  gwlb_name         = "${var.name_prefix}-vzen-gwlb-${random_string.suffix.result}"
  target_group_name = "${var.name_prefix}-vzen-target-${random_string.suffix.result}"
}

resource "tls_private_key" "key" {
  algorithm = var.tls_key_algorithm
}

resource "aws_key_pair" "deployer" {
  key_name   = local.key_name
  public_key = tls_private_key.key.public_key_openssh
}

resource "local_file" "private_key" {
  content         = tls_private_key.key.private_key_pem
  filename        = local.file_name
  file_permission = "0600"
}

################################################################################
# 1. Create/reference all network infrastructure resource dependencies for all 
#    child modules (vpc, igw, subnets, route tables)
################################################################################
module "network" {
  source                   = "../../modules/terraform-zsvzen-network-aws"
  name_prefix              = var.name_prefix
  resource_tag             = random_string.suffix.result
  global_tags              = local.global_tags
  az_count                 = var.az_count
  vpc_cidr                 = var.vpc_cidr
  byo_new_subnet_cidr      = var.byo_new_subnet_cidr
  gwlb_enabled             = true
  gwlb_endpoint_ids        = module.gwlb_endpoint.gwlbe

  #bring-your-own variables
  brownfield_deployment             = var.brownfield_deployment
  byo_vpc_id                        = var.byo_vpc_id
  byo_igw_id                        = var.byo_igw_id
  byo_subnet_ids                    = var.byo_subnet_ids

}


################################################################################
# 4. Create specified number VZEN VMs which will span equally across 
#    designated availability zones per az_count. E.g. vzen_count set to 4 and 
#    az_count set to 2 will create 2x VZENs in AZ1 and 2x VZENs in AZ2
################################################################################

# Write the file to local filesystem for storage/reference
################################################################################
# Locate Latest VZEN AMI by product code
################################################################################
data "aws_ami" "vzen_ami" {
  most_recent = true

  filter {
    name   = "product-code"
    #change product code value for China marketplace - to.be.done.EIO-6655
    values = var.aws_region == "cn-north-1" || var.aws_region == "cn-northwest-1" ? ["china-vse-product-code-goes-here"] : ["7mzoi13353qz115eaksatb0yp"]
  }

  owners = ["aws-marketplace"]
}

# Create specified number of VZEN appliances
module "vzen_vm" {
  source                             = "../../modules/terraform-zsvzen-vm-aws"
  vzen_count                         = var.vzen_count
  ami_id                             = var.set_your_own_ami_id == "" ? data.aws_ami.vzen_ami.id : var.set_your_own_ami_id
  name_prefix                        = var.name_prefix
  resource_tag                       = random_string.suffix.result
  global_tags                        = local.global_tags
  mgmt_subnet_id                     = module.network.vzen_subnet_ids
  service_subnet_id                  = module.network.vzen_subnet_ids
  instance_key                       = aws_key_pair.deployer.key_name
  vzen_vm_instance_type              = var.vzen_vm_instance_type
  iam_instance_profile               = module.vzen_iam.iam_instance_profile_id
  mgmt_security_group_id             = module.vzen_sg.mgmt_security_group_id
  service_security_group_id          = module.vzen_sg.service_security_group_id
  hostname_type                      = var.hostname_type
}


################################################################################
# 5. Create IAM Policy, Roles, and Instance Profiles to be assigned to VZEN. 
#    Default behavior will create 1 of each IAM resource per VZEN VM. Set variable 
#    "reuse_iam" to true if you would like a single IAM profile created and 
#    assigned to ALL VZENs instead.
################################################################################
module "vzen_iam" {
  source             = "../../modules/terraform-zsvzen-iam-aws"
  iam_count          = var.reuse_iam == false ? var.vzen_count : 1
  name_prefix        = var.name_prefix
  resource_tag       = random_string.suffix.result
  global_tags        = local.global_tags
}


################################################################################
# 6. Create Security Group and rules to be assigned to VZEN mgmt and and service 
#    interface(s). Default behavior will create 1 of each SG resource per VZEN VM. 
#    Set variable "reuse_security_group" to true if you would like a single 
#    security group created and assigned to ALL VZENs instead.
################################################################################
module "vzen_sg" {
  source                         = "../../modules/terraform-zsvzen-sg-aws"
  sg_count                       = var.reuse_security_group == false ? var.vzen_count : 1
  name_prefix                    = var.name_prefix
  resource_tag                   = random_string.suffix.result
  global_tags                    = local.global_tags
  vpc_id                         = module.network.vpc_id
  mgmt_ssh_enabled               = var.mgmt_ssh_enabled
  all_ports_egress_enabled       = var.all_ports_egress_enabled
  vzen_mgmt_sg_allowed_ssh_ips   = var.vzen_mgmt_sg_allowed_ssh_ips

  byo_security_group = var.byo_security_group
  # optional inputs. only required if byo_security_group set to true
  byo_mgmt_security_group_id    = var.byo_mgmt_security_group_id
  byo_service_security_group_id = var.byo_service_security_group_id
  # optional inputs. only required if byo_security_group set to true
}

################################################################################
# 7. Create GWLB in all VZEN subnets/availability zones. Create a Target Group 
#    and attach primary service IP from all created VZENs as registered targets.
################################################################################
module "gwlb" {
  source                = "../../modules/terraform-zsvzen-gwlb-aws"
  gwlb_name             = local.gwlb_name
  target_group_name     = local.target_group_name
  global_tags           = local.global_tags
  vpc_id                = module.network.vpc_id
  vzen_subnet_ids       = module.network.vzen_subnet_ids
  vzen_service_ips      = module.vzen_vm.forwarding_ip
  http_probe_port       = var.http_probe_port
  health_check_interval = var.health_check_interval
  healthy_threshold     = var.healthy_threshold
  unhealthy_threshold   = var.unhealthy_threshold
  cross_zone_lb_enabled = var.cross_zone_lb_enabled
  rebalance_enabled     = var.rebalance_enabled
}

################################################################################
# 8. Create a VPC Endpoint Service associated with GWLB and 1x GWLB Endpoint
#    per VZEN subnet/availability zone.
################################################################################
module "gwlb_endpoint" {
  source              = "../../modules/terraform-zsvzen-gwlbendpoint-aws"
  name_prefix         = var.name_prefix
  resource_tag        = random_string.suffix.result
  global_tags         = local.global_tags
  vpc_id              = module.network.vpc_id
  vzen_subnet_ids     = module.network.vzen_subnet_ids
  gwlb_arn            = module.gwlb.gwlb_arn
  acceptance_required = var.acceptance_required
  allowed_principals  = var.allowed_principals
}
