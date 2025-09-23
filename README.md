# AWS-VPC-FOR-EKS

DevOps Tutorials wirtten by Pengchao Ma ,This terraform will create the vpc with public and private subnets for EKS and will also create the vpc endpoint interface and a bastion server with ubuntu installed

## Features

- Creates a VPC with specified CIDR block
- Creates 3 public subnets across different availability zones with EKS tags
- Creates 3 private subnets across different availability zones with EKS tags
- Creates an Internet Gateway for public subnets
- Creates a NAT Gateway for 3 private subnets
- Sets up route tables for public and private subnets
- Creates an SSH key pair from the provided public key
- Deploys a Ubuntu bastion host in the public subnet with SSH access
- Creates a VPC Endpoint for different aws servies like ecr,asg,s3...

## Usage

- give your values on main.tf directly:
```terraform
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  availability_zones  = ["us-east-1a", "us-east-1b", "us-east-1c"]
  environment         = "development"
  bastion_instance_type = "t2.micro"
  ssh_public_key      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC/h331ZWQQggV5Pp78eQ18Qi3lOytWJhuGacssp5gTCmuIzmMfIW+t0fhDjWq6uda1t7NeYTh0zu5+36vkiy5s3Gr1M764X3qGKeGFmC7qe1kyF7RtVoZ4adufBgoNxtWi9zGmSBVi3G98YLhq0Tuj0mV9FT9l1F3NBOd3YbtCSWJ3Lx3WH9hMJ7eGAsBek8hatCtlDIFMQeF/xW4WBufWYkghjJE0G/Z9q4bJewrERD4B7GlDe+GGN8wAvehKKASySWgeeIwu+w6LYR7yzi+hyCCL+jyiycJ113u0gMo/oavdlFlVUeoJhmjsL46sjpgKPr2Yb0GhEVBOCW/rBXPFq+24zx/uds1PK/HtVNanr5kQBpJ4yT57hKhKhuNXWhJwuwQpzEFkwt36RqNFC/7CpH0BiRaafHDggBSnzPsNEECHnPnfgvzfcKoxMNcbbgYwZxNFEBD2Bjd11T1iS0aIxlO7RA2IMGl0Ch03lE3ztbiafRVIw6pTy09ehi7e+NE= pengchaoma@Pengchaos-MacBook-Pro.local"
}

```
- write variables.tf and terraform.tfvars for multiple vpcs creation


