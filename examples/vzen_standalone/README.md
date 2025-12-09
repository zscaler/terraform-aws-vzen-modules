# Zscaler Starter Deployment Template (vzen_standalone)

By default 1 VZEN and corresponding resources will be created.

The number of VZENs can be customized via "vzen_count" variable.<br>

## How to deploy:

### Auth to AWS user with EC2, VPC, IAM admin permissions  

export AWS_PROFILE='AWS_user_profile_name'

additional options: https://registry.terraform.io/providers/hashicorp/aws/latest/docs

### Providing your Inputs:

Modify/populate your required variable input values in examples/vzen_standalone/terraform.tfvars file and save. In case you want to reuse any AWS Resources, you may edit byo_variables.

#### Mandatory Inputs:

- aws_region    : AWS region where VZEN resources will be deployed

#### Optional Inputs:

- vzen_count                    : The number of VZEN EC2 instances
- vzen_mgmt_sg_allowed_ssh_ips  : To allow SSH to VZEN instances from a particular VM
- vzen_vm_instance_type         : AWS EC2 Instance size selection.
- brownfield_deployment         : For brownfield Deployments
- byo_vpc_id                    : To reuse any existing VPC for deployment
- byo_igw_id                    : To reuse any existing Internet Gateway
- byo_subnets_ids               : To reuse existing Subnets
- reuse_security_group          : To use the same Security Group for ALL VZENs
- byo_security_group            : To use your own existing SGs
- byo_mgmt_security_group_id    : SG for Management Interfaces
- byo_service_security_group_id : SG for service Interfaces
- set_your_own_tag                       : Your own tags/for all Resources this terraform will create
- set_your_own_ami_id                    : To override the default Marketplace AMI
- az_count                      : The number of Availability Zones to span subnets across.

## How to deploy:

Modify/populate any required variable input values in examples/vzen_standalone/terraform.tfvars file and save, then export the following variable to specify the name of the AWS CLI profile with the configured credentials.

export AWS_PROFILE=<AWS_profile_set_on_deployment_vm>

From vzen_standalone execute:

- terraform init
- terraform plan
- terraform apply

## How to destroy:

- terraform destroy

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.7, < 2.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.32.0, <= 5.49.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 2.2.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.1.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.3.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 3.4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.32.0, <= 5.49.0 |
| <a name="provider_local"></a> [local](#provider\_local) | ~> 2.2.0 |
| <a name="provider_null"></a> [null](#provider\_null) | ~> 3.1.0 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.3.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | ~> 3.4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_network"></a> [network](#module\_network) | ../../modules/terraform-zsvzen-network-aws | n/a |
| <a name="module_vzen_vm"></a> [vzen\_vm](#module\_vzen\_vm) | ../../modules/terraform-zsvzen-vm-aws | n/a |
| <a name="module_vzen_iam"></a> [vzen\_iam](#module\_vzen\_iam) | ../../modules/terraform-zsvzen-iam-aws | n/a |
| <a name="module_vzen_sg"></a> [vzen\_sg](#module\_vzen\_sg) | ../../modules/terraform-zsvzen-sg-aws | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_key_pair.deployer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [local_file.private_key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [random_string.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [tls_private_key.key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws_region | AWS region where VZEN resources will be deployed | string | "us-west-2" | yes |
| vzen_count | The number of VZEN EC2 Instances | number | 2 | NO |
| vzen_mgmt_sg_allowed_ssh_ips | To allow SSH to VZEN instances from a particular VM | list(string) | ["10.1.0.0/16"] | NO |
| vzen_vm_instance_type | AWS EC2 Instance size selection | string | "m5.2xlarge" | NO |
| brownfield_deployment | To reuse any existing VPC for deployment | string | false | NO |
| byo_vpc_id | To reuse any existing VPC for deployment (ID) | string | "" | NO |
| byo_igw_id | To reuse any existing Internet Gateway (ID) | string | "" | NO |
| byo_subnets_ids | To reuse existing Subnets (IDs) | list(string) | "" | NO |
| reuse_security_group | To use the same Security Group for ALL VZENs | bool | false | NO |
| byo_security_group | To use your own existing SGs | list(string) | false | NO |
| byo_mgmt_security_group_id | SG for Management Interfaces (ID) | string | "" | NO |
| byo_service_security_group_id | SG for Service Interfaces (ID) | string | "" | NO |
| set_your_own_tag | Your own tags for all Resources this terraform will create | map(string) | {} | NO |
| set_your_own_ami_id | To override the default Marketplace AMI (ID) | string | "" | NO |
| az_count | The number of Availability Zones to span subnets across | number | 1 | NO |


## Outputs

| Name | Description |
|------|-------------|
| management_public_ip_addresses | Public SSH IPs of Deployed VZENs |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
