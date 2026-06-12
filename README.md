<a href="https://terraform.io">
    <img src="https://raw.githubusercontent.com/hashicorp/terraform-website/master/public/img/logo-text.svg" alt="Terraform logo" title="Terraform" height="50" width="250" />
</a>
<a href="https://www.zscaler.com/">
    <img src="https://www.zscaler.com/themes/custom/zscaler/logo.svg" alt="Zscaler logo" title="Zscaler" height="50" width="250" />
</a>

Zscaler VZEN AWS Terraform Modules
===========================================================================================================

# **README for AWS VZEN Terraform**
This README serves as a quick start guide to deploy Zscaler VZEN resources in an AWS cloud using Terraform.

## **AWS Deployment Scripts for Terraform**

Use this repository to create the deployment resources required to deploy and operate VZEN in a new or existing virtual private cloud (VPC). The [examples](examples/) directory contains complete automation scripts for both Standalone VZEN and VZEN Cluster using AWS Gateway Load Balancer (GWLB).

## **Prerequisites**

The AWS Terraform scripts require Terraform >= 1.5.0. Terraform 1.5+ includes full binary and provider support for macOS M1 chips.

-   provider registry.terraform.io/hashicorp/aws ~> 6.0
-   provider registry.terraform.io/hashicorp/random ~> 3.9
-   provider registry.terraform.io/hashicorp/local ~> 2.5
-   provider registry.terraform.io/hashicorp/null ~> 3.2
-   provider registry.terraform.io/providers/hashicorp/tls ~> 4.0

### **AWS requirements**

1.  A valid AWS account with Administrator Access to deploy required resources
2.  AWS ACCESS KEY ID
3.  AWS SECRET ACCESS KEY
4.  AWS Region (E.g. us-west-2)
5.  Subscribe and accept the terms of using Zscaler VZEN image at [this link](https://aws.amazon.com/marketplace/pp/prodview-ex2z2yzqrdsb6)
6. Install [Terraform CLI](https://aws.amazon.com/marketplace/pp/prodview-ex2z2yzqrdsb6)

### **Zscaler requirements**
 
7.  Must have Zscaler VZEN SKUs Subscription
8.  Zscaler Admin UI Credentials

## **Starter Deployment Template - Standalone**

Use the [**Starter Deployment Template**](examples/vzen_standalone/) to deploy your Virtual Service Edge (VZEN) in a new VPC.

## **Starter Deployment Template - Gateway Load Balancer (GWLB)**

Use the [**Starter Deployment Template with GWLB**](examples/vzen_with_gwlb/) to deploy your Virtual Service Edges (VZENs) in a new VPC and to load balance traffic across multiple VZENs. Zscaler\'s recommended deployment method is Gateway Load Balancer (GWLB). GWLB distributes traffic across multiple VZENs and achieves high availability.

## **Greenfield Deployment vs Brownfield Deployment**

For brownfield deployments, update the BYO (Bring Your Own) Terraform variables as needed to align with the deployment requirements.
