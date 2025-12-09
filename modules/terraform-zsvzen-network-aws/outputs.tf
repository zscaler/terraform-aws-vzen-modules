output "vpc_id" {
  description = "VPC ID"
  value       = try(data.aws_vpc.vpc_selected[0].id, aws_vpc.vpc[0].id)
}

output "vzen_subnet_ids" {
  description = "VZEN Subnet ID"
  value       = data.aws_subnet.vzen_subnet_selected[*].id
}