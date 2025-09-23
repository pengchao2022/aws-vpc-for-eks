# variables.tf

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "172.20.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["172.20.1.0/24", "172.20.2.0/24", "172.20.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["172.20.101.0/24", "172.20.102.0/24", "172.20.103.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "development"
}

variable "bastion_instance_type" {
  description = "Instance type for bastion host"
  type        = string
  default     = "t3.micro"
}

variable "ssh_public_key" {
  description = "SSH public key for bastion host"
  type        = string
  sensitive   = true
}

variable "eks_cluster_names" {
  description = "List of EKS cluster names"
  type        = list(string)
  default     = ["dev-spring-eks-cluster"]
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "create_vpc_endpoints" {
  description = "Whether to create VPC endpoints"
  type        = bool
  default     = true
}