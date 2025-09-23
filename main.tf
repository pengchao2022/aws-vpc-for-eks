module "development_vpc" {
  source                = "./modules/vpc"
  vpc_cidr              = var.vpc_cidr
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  availability_zones    = var.availability_zones
  environment           = var.environment
  bastion_instance_type = var.bastion_instance_type
  ssh_public_key        = var.ssh_public_key
  eks_cluster_names     = var.eks_cluster_names
  region                = var.region
  create_vpc_endpoints  = var.create_vpc_endpoints
}