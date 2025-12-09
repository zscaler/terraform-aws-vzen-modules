################################################################################
# Network Infrastructure Resources
################################################################################
# Identify availability zones available for region selected
data "aws_availability_zones" "available" {
  state = "available"
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}


################################################################################
# VPC
################################################################################
# Create a new VPC
resource "aws_vpc" "vpc" {
  count                = var.brownfield_deployment == true && var.byo_vpc_id != "" ? 0 : 1
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = false

  tags = merge(var.global_tags,
    { Name = "${var.name_prefix}-vpc-${var.resource_tag}" }
  )
}

# Or reference an existing VPC
data "aws_vpc" "vpc_selected" {
  count = var.brownfield_deployment == true && var.byo_vpc_id != "" ? 1 : 0
  id    = var.byo_vpc_id
}


################################################################################
# Internet Gateway
################################################################################
# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  count  = var.brownfield_deployment == true && var.byo_igw_id != "" ? 0 : 1
  vpc_id = try(data.aws_vpc.vpc_selected[0].id, aws_vpc.vpc[0].id)

  tags = merge(var.global_tags,
    { Name = "${var.name_prefix}-igw-${var.resource_tag}" }
  )
}

# Or reference an existing Internet Gateway
data "aws_internet_gateway" "igw_selected" {
  internet_gateway_id = var.brownfield_deployment == true && var.byo_igw_id != "" ? var.byo_igw_id : aws_internet_gateway.igw[0].id
}


################################################################################
# Public (VZEN) Subnet & Route Tables
################################################################################
# Create subnet for VZEN network in X availability zones per az_count variable
resource "aws_subnet" "vzen_subnet" {
  count = var.brownfield_deployment == true && var.byo_subnet_ids != null ? 0 : var.az_count

  availability_zone                           = data.aws_availability_zones.available.names[count.index]
  cidr_block                                  = var.byo_new_subnet_cidr != null ? var.byo_new_subnet_cidr  : cidrsubnet(try(data.aws_vpc.vpc_selected[0].cidr_block, aws_vpc.vpc[0].cidr_block), 8, count.index + 200)
  vpc_id                                      = try(data.aws_vpc.vpc_selected[0].id, aws_vpc.vpc[0].id)

  tags = merge(var.global_tags,
    { Name = "${var.name_prefix}-vzen-subnet-${count.index + 1}-${var.resource_tag}" }
  )
}

# Or reference existing subnets
data "aws_subnet" "vzen_subnet_selected" {
  count = var.brownfield_deployment == true && var.byo_subnet_ids != null ? length(var.byo_subnet_ids) : var.az_count
  id    = var.brownfield_deployment == true && var.byo_subnet_ids != null ? element(var.byo_subnet_ids, count.index) : aws_subnet.vzen_subnet[count.index].id
}

# Create Route Tables for VZEN subnets pointing to Internet Gateway resource in each AZ
resource "aws_route_table" "vzen_rt" {
  count  = var.brownfield_deployment == true && var.byo_subnet_ids != null ? 0 : length(data.aws_subnet.vzen_subnet_selected[*].id)
  vpc_id = try(data.aws_vpc.vpc_selected[0].id, aws_vpc.vpc[0].id)

  route {
    cidr_block      = "0.0.0.0/0"
    gateway_id      = var.brownfield_deployment == false ? aws_internet_gateway.igw[0].id : var.byo_igw_id
  }

  tags = merge(var.global_tags,
    { Name = "${var.name_prefix}-vzen-rt-${count.index + 1}-${var.resource_tag}" }
  )
}

# VZEN subnet Route Table Association
resource "aws_route_table_association" "vzen_rt_asssociation" {
  count          = var.brownfield_deployment == true && var.byo_subnet_ids != null ? 0 : length(data.aws_subnet.vzen_subnet_selected[*].id)
  subnet_id      = data.aws_subnet.vzen_subnet_selected[count.index].id
  route_table_id = aws_route_table.vzen_rt[count.index].id
}
