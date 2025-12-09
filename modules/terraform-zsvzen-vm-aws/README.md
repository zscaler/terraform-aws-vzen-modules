# Zscaler VZEN / AWS EC2 Instance (VZEN) Module

This module creates all AWS EC2 instance and network interface resources needed to deploy VZEN appliances.

 
## Subscribe to the AWS Marketplace

Subscribe and accept terms of using Zscaler VZEN image at [this link](https://aws.amazon.com/marketplace/pp/prodview-ex2z2yzqrdsb6). 
For China marketplace deployments, #TO-DO

| AWS Cloud                  | Product Code              |  Version                                       |
|:--------------------------:|:-------------------------:|:----------------------------------------------:|
| aws (Commercial)           | 7mzoi13353qz115eaksatb0yp |  vzen42.422701.161(Latest - as of March, 2025) |
| aws-us-gov (US Government) | #to-do                    | -                                              |
| aws-cn (China)             | #to-do                    | -                                              |

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.7, < 2.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.32 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 2.2.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.32 |
| <a name="provider_null"></a> [null](#provider\_null) | ~> 3.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.vzen_vm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [null_resource.wait_for_vzens](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_network_interface.vzen_vm_nic_index_0](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface) | resource |
| [null_resource.wait_for_management_nics](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_eip.eip_management_interface](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |

| [aws_network_interface.vzen_vm_nic_index_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface) | resource |
| [null_resource.wait_for_service_nics](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_eip.eip_service_interface](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_vzen_count"></a> [vzen\_count](#input\_vzen\_count) | Default number of VZEN appliances to create | `number` | `1` | no |
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | AMI ID to be used for deploying VZEN appliances. Ideally all VMs should be on the same AMI ID as templates always pull the latest from AWS Marketplace. This variable is provided if a customer desires to override/retain an old ami for existing deployments rather than upgrading and forcing a replacement. | `string` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | A prefix to associate to all the VZEN module resources | `string` | `null` | no |
| <a name="input_resource_tag"></a> [resource\_tag](#input\_resource\_tag) | A tag to associate to all the VZEN module resources | `string` | `null` | no |
| <a name="input_global_tags"></a> [global\_tags](#input\_global\_tags) | Populate any custom user defined tags from a map | `map(string)` | `{}` | no |
| <a name="input_mgmt_subnet_id"></a> [mgmt\_subnet\_id](#input\_mgmt\_subnet\_id) | VZEN EC2 Instance management subnet id | `list(string)` | n/a | yes |
| <a name="input_service_subnet_id"></a> [service\_subnet\_id](#input\_service\_subnet\_id) | VZEN EC2 Instance service subnet id | `list(string)` | n/a | yes |
| <a name="input_instance_key"></a> [instance\_key](#input\_instance\_key) | SSH Key for instances | `string` | n/a | yes |
| <a name="input_vzen_vm_instance_type"></a> [vzen\_vm\_instance\_type](#input\_vzen\_vm\_instance\_type) | VZEN Instance Type | `string` | `"m5.2xlarge"` | no |
| <a name="input_iam_instance_profile"></a> [iam\_instance\_profile](#input\_iam\_instance\_profile) | IAM instance profile ID assigned to VZEN | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_availability_zone"></a> [availability\_zone](#output\_availability\_zone) | Instance Availability Zone |
| <a name="output_forwarding_eni"></a> [forwarding\_eni](#output\_forwarding\_eni) | Instance Device Index 0 Network ID |
| <a name="output_forwarding_ip"></a> [forwarding\_ip](#output\_forwarding\_ip) | Instance Forwarding/Service IP |
| <a name="output_id"></a> [id](#output\_id) | EC2 Instance ID |
| <a name="output_management_eni"></a> [management\_eni](#output\_management\_eni) | Instance Device Index 1 Network ID |
| <a name="output_management_ip"></a> [management\_ip](#output\_management\_ip) | Instance Device Index 1 Private IP |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
