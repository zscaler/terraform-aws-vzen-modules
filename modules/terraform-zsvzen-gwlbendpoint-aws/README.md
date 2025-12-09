# Zscaler VZEN / AWS Gateway Load Balancer Endpoint and Endpoint Service Module

This module creates Gateway Load Balancer Endpoint (GWLBE) and VPC Endpoint Service for GWLB resources. Endpoint service associates to a GWLB ARN input and Endpoints associate to a list of Subnet ID inputs.

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
| [aws_vpc_endpoint_service.gwlb_vpce_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_service) | resource |
| [aws_vpc_endpoint.gwlb_vpce](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VZEN VPC ID | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of Subnet ID to create GLWB Endpoints in | `list(string)` | n/a | yes |
| <a name="input_gwlb_arn"></a> [gwlb\_arn](#input\_gwlb\_arn) | ARN of GWLB for Endpoint Service to be assigned | `string` | n/a | yes |
| <a name="input_acceptance_required"></a> [acceptance\_required](#input\_acceptance\_required) | Whether to require manual acceptance of any VPC Endpoint registration attempts to the Endpoint Service or not. Default is false | `bool` | `false` | no |
| <a name="input_allowed_principals"></a> [allowed\_principals](#input\_allowed\_principals) | List of AWS Principal ARNs who are allowed access to the GWLB Endpoint Service. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_gwlbe"></a> [gwlbe](#output\_gwlbe) | GWLB Endpoint ID |
| <a name="output_vpce_service_arn"></a> [vpce\_service\_arn](#output\_vpce\_service\_arn) | VPC Endpoint Service ARN |
| <a name="output_vpce_service_id"></a> [vpce\_service\_id](#output\_vpce\_service\_id) | VPC Endpoint Service ID |
| <a name="output_vpce_service_name"></a> [vpce\_service\_name](#output\_vpce\_service\_name) | VPC Endpoint Service Name |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
