variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "bastion_instance_type" {
  description = "Instance type for bastion host"
  type        = string
  default     = "t3.micro"
}

variable "ssh_public_key" {
  description = "SSH public key for bastion host"
  type        = string
}

variable "eks_cluster_names" {
  description = "List of EKS cluster names that will use this VPC"
  type        = list(string)
  default     = []
}

variable "eks_cluster_name" {
  description = "Name of the EKS cluster (deprecated, use eks_cluster_names instead)"
  type        = string
  default     = ""
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "create_vpc_endpoints" {
  description = "Whether to create VPC endpoints for EKS"
  type        = bool
  default     = false
}