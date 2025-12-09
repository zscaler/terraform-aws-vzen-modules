# Zscaler VZEN / AWS Security Groups Module

This module creates Security Rules and Groups resources required for successful VZEN deployments. As part of Zscaler provided deployment templates most resources have conditional create options leveraged "byo" variables should a customer want to leverage the module outputs with data reference to resources that may already exist in their AWS environment. Security Group rules are populated per Zscaler connectivity requirements and minimum access best practices.
 
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
| [aws_security_group.vzen_mgmt_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_vpc_security_group_egress_rule.egress_vzen_management](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_security_group.ssh](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.vzen_mgmt_sg_selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.vzen_service_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.vzen_service_sg_selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.egress_vzen_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.ingress_vzen_service_all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_sg_count"></a> [sg\_count](#input\_sg\_count) | Default number of security groups to create | `number` | `1` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VZEN VPC ID | `string` | n/a | yes |
| <a name="input_mgmt_ssh_enabled"></a> [mgmt\_ssh\_enabled](#input\_mgmt\_ssh\_enabled) | Default is true which creates an ingress rule permitting SSH traffic to the VZEN management interface. If false, the rule is not created. Value ignored if not creating a security group | `bool` | `true` | no |
| <a name="input_all_ports_egress_enabled"></a> [all\_ports\_egress\_enabled](#input\_all\_ports\_egress\_enabled) | Default is true which creates an egress rule permitting the VZEN service interface to forward direct traffic on all ports and protocols. If false, the rule is not created. Value ignored if not creating a security group | `bool` | `true` | no |
| <a name="input_byo_security_group"></a> [byo\_security\_group](#input\_byo\_security\_group) | Bring your own Security Group for VZEN. Setting this variable to true will effectively instruct this module to not create any resources and only reference data resources from values provided in byo\_mgmt\_security\_group\_id and byo\_service\_security\_group\_id | `bool` | `false` | no |
| <a name="input_byo_mgmt_security_group_id"></a> [byo\_mgmt\_security\_group\_id](#input\_byo\_mgmt\_security\_group\_id) | Management Security Group ID for VZEN association | `list(string)` | `null` | no |
| <a name="input_byo_service_security_group_id"></a> [byo\_service\_security\_group\_id](#input\_byo\_service\_security\_group\_id) | Service Security Group ID for VZEN association | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_mgmt_security_group_arn"></a> [mgmt\_security\_group\_arn](#output\_mgmt\_security\_group\_arn) | Instance Management Security Group ARN |
| <a name="output_mgmt_security_group_id"></a> [mgmt\_security\_group\_id](#output\_mgmt\_security\_group\_id) | Instance Management Security Group ID |
| <a name="output_service_security_group_id"></a> [service\_security\_group\_id](#output\_service\_security\_group\_id) | Instance Service Security Group ID |
| <a name="output_service_security_group_arn"></a> [service\_security\_group\_arn](#output\_service\_security\_group\_arn) | Instance Service Security Group ARN |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
