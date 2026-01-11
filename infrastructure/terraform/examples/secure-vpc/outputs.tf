output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = var.vpc_cidr
}

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = module.vpc.nat_gateway_ids
}

output "vpc_flow_logs_group" {
  description = "Name of the VPC Flow Logs CloudWatch Log Group"
  value       = module.vpc.flow_logs_group_name
}

output "kms_key_arn" {
  description = "ARN of the KMS key used for VPC Flow Logs encryption"
  value       = aws_kms_key.vpc_logs.arn
}

output "kms_key_alias" {
  description = "Alias of the KMS key used for VPC Flow Logs encryption"
  value       = aws_kms_alias.vpc_logs.name
}
