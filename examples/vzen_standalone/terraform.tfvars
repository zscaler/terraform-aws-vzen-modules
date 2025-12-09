## This is only a sample terraform.tfvars file.
## Uncomment and change the below variables according to your specific environment.
## By default, it'll be a greenfield deployment.
## If your AWS Infra is already configured with Zscaler VSEs, you can use the brownfield deployment mode.


#############################################################################################
# AWS Region - Mandatory
#############################################################################################
## AWS region where VZEN resources will be deployed.
## (Default: us-west-2)

# aws_region                                 = "us-east-1"


#############################################################################################
# VZEN Count
#############################################################################################
## The number of VZEN EC2 Instances
## Default: 1 VZEN

# vzen_count                                  = "2"


#############################################################################################
# Custom SSH Allowed IP
#############################################################################################
## By default, VZEN is a member of a security group that restricts access via SSH from any public IP.
## Uncomment vzen_mgmt_sg_allowed_ssh_ips to allow SSH from a particular VM
## Default: ["10.1.0.0/16"]

# vzen_mgmt_sg_allowed_ssh_ips                      = ["a.b.c.d/32"]


#############################################################################################
# VZEN EC2 Instance Type
#############################################################################################
## VZEN AWS EC2 instance size selection. Specify desired vm size to change.
## Allowed Types: "m5.2xlarge" or "r5.2xlarge"
## Default: "m5.2xlarge"

# vzen_vm_instance_type                      = "m5.2xlarge"


#############################################################################################
# Is it brownfield Deployment ?
#############################################################################################
## By default it will be a greenfield deployment
## Uncomment if you want to deploy all resources in an AWS Infra which already has VZEN Deployments (true or false. Default: false)
## Provide your existing AWS resources by unsetting byo_<variables> (Default: null)
## If this is set to true, you must input byo_vpc_id, byo_igw_id and byo_subnet_ids.

# brownfield_deployment                      = true


#############################################################################################
# BYO VPC
#############################################################################################

## Uncomment if you want to deploy all resources to a VPC that already exists (true or false. Default: false)
## Provide your existing VPC ID. Only uncomment and modify if you set brownfield_deployment to true. (Default: null)
## You must also provide the Internet Gateway attached to it in the variable "byo_igw_id" below.
## Example: byo_vpc_id = "vpc-09fe7ba69c4646631"

# byo_vpc_id                                 = "vpc-0f58018470fc6d8eb"


#############################################################################################
# BYO Internet Gateway
#############################################################################################

## Uncomment if you want to utlize an IGW that already exists (true or false. Default: false)
## Requires byo_vpc_id to be a valid vpc and the BYO IGW must already be attached to that VPC.
## Provide your existing Internet Gateway ID. Only uncomment and modify if you set brownfield_deployment to true. (Default: null)
## Example: byo_igw_id = "igw-0d15d802f81c53b11"

# byo_igw_id                                 = "igw-09c8396f66da7d6a6"


#############################################################################################
# BYO Subnets
#############################################################################################
## Provide your existing VZEN public-subnet IDs.
## Subnet IDs must be added as a list. Provide only one subnet per Availability Zone in a VPC.
## Only uncomment and modify if you set brownfield_deployment to true. (Default: null)
## Incase you want to deploy a new subnet, leave byo_subnet_ids as null, enter byo_new_subnet_cidr.
## Example: byo_vzen_subnet_ids = ["subnet-03a26c4fe072b603d","subnet-0f9cce8ad2330899f"]

# byo_subnet_ids                             = ["subnet-01f70e1a9a3d38721"]


#############################################################################################
# BYO New_Subnet_CIDR
#############################################################################################
## Only for brownfield deployments, where new public subnets need to be created for VZENs.
## Provide the CIDR block value for the subnets corresponding to your byo_vpc_id, to avoid conflicts with another subnet.
## If you already have a subnet, do not enter any value, and let it be as it is.
## The new subnets which will be created will have their own Route Table and RT-Associations.
## Subnet_CIDR must be added as a string.
## Example: byo_new_subnet_cidr = "10.1.101.0/24". (Default: null)

# byo_new_subnet_cidr                            = "10.1.101.0/24"


#############################################################################################
# BYO Security Groups
#############################################################################################
## By default, this script will create new Security Groups for the VZEN management and service interfaces
## Uncomment if you want to use your own existing SGs.
## Provide your existing Security Group resource names. Only uncomment and modify if you set byo_security_group to true
## Example: byo_mgmt_security_group_id     = ["sg-0110bef3440eb3a0b"]
## Example: byo_service_security_group_id  = ["sg-0405e6253e0aabe24"]

# byo_security_group                          = true
# byo_mgmt_security_group_id                  = ["sg-0098fd61660db7bc4"]
# byo_service_security_group_id               = ["sg-0110bef3440eb3a0b"]


#############################################################################################
# Re-Use Security Groups
#############################################################################################
## By default, this script will apply 1 Security Group per VZEN instance.
## Uncomment if you want to use the same Security Group for ALL VZENs (true or false. Default: false)

# reuse_security_group                       = true


#############################################################################################
# Set Your Own Tags
#############################################################################################
## Default is a blank dict, If you want to give tags, uncomment set_your_own_tags, and Input Key-Value Pair representing ( tag,value ).

# set_your_own_tag                                   = {
#     Owner                                                                                 = "Owner"
#     ManagedBy                                                                             = "terraform"
#     Vendor                                                                                = "Zscaler"
#   }


#############################################################################################
# VZEN AMI ID
#############################################################################################
## Uncomment this and provide an AMI ID to override the default Marketplace AMI.

# set_your_own_ami_id                                   = "ami-0b60395b5e3c09e2d"


#############################################################################################
# AWS az_count
#############################################################################################
## The number of Availability Zones to span subnets across. By default we will only span across 1 AZ,
## If brownfield_deployment is set, then it will be equal to the number of subnets provided.
## Default = 1
## Minumum: 1 - Maximum: 3

# az_count                                   = "1"
