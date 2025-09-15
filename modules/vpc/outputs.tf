output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

output "bastion_host_public_ip" {
  description = "Public IP address of the bastion host"
  value       = aws_instance.bastion.public_ip
}

output "bastion_host_private_ip" {
  description = "Private IP address of the bastion host"
  value       = aws_instance.bastion.private_ip
}

output "bastion_host_id" {
  description = "ID of the bastion host instance"
  value       = aws_instance.bastion.id
}

output "nat_gateway_public_ip" {
  description = "Public IP address of the NAT Gateway"
  value       = aws_eip.nat.public_ip
}

# VPC Endpoints 相关输出
output "vpc_endpoint_ids" {
  description = "Map of VPC endpoint IDs by service name"
  value       = { for endpoint in aws_vpc_endpoint.eks : endpoint.service_name => endpoint.id }
}

output "vpc_endpoint_arns" {
  description = "Map of VPC endpoint ARNs by service name"
  value       = { for endpoint in aws_vpc_endpoint.eks : endpoint.service_name => endpoint.arn }
}

output "vpc_endpoint_dns_entries" {
  description = "Map of VPC endpoint DNS entries by service name"
  value       = { for endpoint in aws_vpc_endpoint.eks : endpoint.service_name => endpoint.dns_entry }
}

output "vpc_endpoint_service_names" {
  description = "List of VPC endpoint service names"
  value       = [for endpoint in aws_vpc_endpoint.eks : endpoint.service_name]
}

output "vpc_endpoint_types" {
  description = "Map of VPC endpoint types by service name"
  value       = { for endpoint in aws_vpc_endpoint.eks : endpoint.service_name => endpoint.vpc_endpoint_type }
}

output "vpc_endpoint_status" {
  description = "Map of VPC endpoint status by service name"
  value       = { for endpoint in aws_vpc_endpoint.eks : endpoint.service_name => endpoint.state }
}

output "interface_vpc_endpoints" {
  description = "Map of interface VPC endpoint details"
  value = { for endpoint in aws_vpc_endpoint.eks :
    endpoint.service_name => {
      id                    = endpoint.id
      dns_entry             = endpoint.dns_entry
      network_interface_ids = endpoint.network_interface_ids
      private_dns_enabled   = endpoint.private_dns_enabled
    } if endpoint.vpc_endpoint_type == "Interface"
  }
}

output "gateway_vpc_endpoints" {
  description = "Map of gateway VPC endpoint details"
  value = { for endpoint in aws_vpc_endpoint.eks :
    endpoint.service_name => {
      id        = endpoint.id
      dns_entry = endpoint.dns_entry
    } if endpoint.vpc_endpoint_type == "Gateway"
  }
}

output "vpc_endpoint_security_group_id" {
  description = "ID of the security group for VPC endpoints"
  value       = try(aws_security_group.vpc_endpoint[0].id, null)
}

output "security_group_ids" {
  description = "IDs of the security groups"
  value = {
    bastion      = aws_security_group.bastion.id
    vpc_endpoint = try(aws_security_group.vpc_endpoint[0].id, null)
  }
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.main.id
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "ID of the private route table"
  value       = aws_route_table.private.id
}

output "availability_zones" {
  description = "List of availability zones used by subnets"
  value       = var.availability_zones
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}