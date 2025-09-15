output "bastion_public_ip" {
  description = "Public IP address of the bastion host"
  value       = module.development_vpc.bastion_host_public_ip
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.development_vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.development_vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.development_vpc.private_subnet_ids
}

# VPC Endpoints 输出
output "vpc_endpoint_ids" {
  description = "Map of VPC endpoint IDs by service name"
  value       = module.development_vpc.vpc_endpoint_ids
}



output "vpc_endpoint_security_group_id" {
  description = "Security group ID for VPC endpoints"
  value       = module.development_vpc.vpc_endpoint_security_group_id
}

# 其他可选输出
output "bastion_private_ip" {
  description = "Private IP address of the bastion host"
  value       = module.development_vpc.bastion_host_private_ip
}

output "bastion_instance_id" {
  description = "ID of the bastion host instance"
  value       = module.development_vpc.bastion_host_id
}

output "nat_gateway_ip" {
  description = "Public IP of the NAT Gateway"
  value       = module.development_vpc.nat_gateway_public_ip
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = module.development_vpc.vpc_cidr_block
}