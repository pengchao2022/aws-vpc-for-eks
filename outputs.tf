output "bastion_public_ip" {
  value = module.development_vpc.bastion_host_public_ip
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.development_vpc.vpc_id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.development_vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.development_vpc.private_subnet_ids
}
