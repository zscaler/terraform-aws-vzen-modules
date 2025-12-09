# Zscaler VZEN / AWS Network Infrastructure Module

This module has multi-purpose use and is leveraged by all other Zscaler VZEN child modules in some capacity.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements
 
| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.7, < 2.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.32 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.32 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_subnet.vzen_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_route_table.vzen_rt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.vzen_rt_asssociation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_az_count"></a> [az\_count](#input\_az\_count) | Default number of subnets to create based on availability zone input | `number` | `1` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | VPC IP CIDR Range | `string` | `"10.1.0.0/16"` | no |
| <a name="input_byo_new_subnet_cidr"></a> [vpc\_cidr](#input\_byo\_new\_subnet\_cidr) | Brownfiled New Subnets CIDR Range | `string` | `null` | no |
| <a name="input_vzen_subnets"></a> [vzen\_subnets](#input\_vzen\_subnets) | VZEN Subnets to create in VPC. | `list(string)` | `null` | no |
| <a name="input_gwlb_enabled"></a> [gwlb\_enabled](#input\_gwlb\_enabled) | Default is false. If run in vzen_with_gwlb examples, it'll auto-set to True | `bool` | `false` | no |
| <a name="input_gwlb_endpoint_ids"></a> [gwlb\_endpoint\_ids](#input\_gwlb\_endpoint\_ids) | List of GWLB Endpoint IDs for use in workload. Utilized if var.gwlb\_enabled is set to true | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_byo_vpc_id"></a> [byo\_vpc\_id](#input\_byo\_vpc\_id) | User provided existing AWS VPC ID | `string` | `null` | no |
| <a name="input_byo_igw_id"></a> [byo\_igw\_id](#input\_byo\_igw\_id) | User provided existing AWS Internet Gateway ID | `string` | `null` | no |
| <a name="input_byo_subnet_ids"></a> [byo\_subnet\_ids](#input\_byo\_subnet\_ids) | User provided existing AWS Subnet IDs for VZEN instances | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | VPC ID |
| <a name="output_vzen_subnet_ids"></a> [vzen\_subnet\_ids](#output\_vzen\_subnet\_ids) | VZEN Subnet ID |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
