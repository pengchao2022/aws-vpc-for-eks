# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "vpc-${var.environment}"
    Environment = var.environment
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "igw-${var.environment}"
    Environment = var.environment
  }
}

# Create Public Subnets
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name                                            = "public-subnet-${count.index + 1}-${var.environment}"
    Environment                                     = var.environment
    "kubernetes.io/role/elb"                        = "1"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
  }
}

# Create Private Subnets
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name                                            = "private-subnet-${count.index + 1}-${var.environment}"
    Environment                                     = var.environment
    "kubernetes.io/role/internal-elb"               = "1"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
  }
}

# Create Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name        = "eip-nat-${var.environment}"
    Environment = var.environment
  }
}

# Create NAT Gateway in the first public subnet
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name        = "nat-gw-${var.environment}"
    Environment = var.environment
  }

  depends_on = [aws_internet_gateway.main]
}

# Create Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name        = "public-rt-${var.environment}"
    Environment = var.environment
  }
}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Create Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name        = "private-rt-${var.environment}"
    Environment = var.environment
  }
}

# Associate Private Subnets with Private Route Table
resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# Create VPC Endpoints for EKS
resource "aws_vpc_endpoint" "eks" {
  for_each = toset([
    "ec2",
    "ecr.api",
    "ecr.dkr",
    "s3",
    "logs",
    "sts",
    "autoscaling",
    "elasticloadbalancing"
  ])

  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.region}.${each.key}"
  vpc_endpoint_type   = each.key == "s3" ? "Gateway" : "Interface"
  private_dns_enabled = each.key != "s3"

  security_group_ids = each.key == "s3" ? null : [aws_security_group.vpc_endpoint.id]
  subnet_ids         = each.key == "s3" ? null : aws_subnet.private[*].id

  tags = {
    Name        = "vpc-endpoint-${each.key}-${var.environment}"
    Environment = var.environment
  }
}

# Security Group for VPC Endpoints
resource "aws_security_group" "vpc_endpoint" {
  name        = "vpc-endpoint-sg-${var.environment}"
  description = "Security group for VPC endpoints"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "vpc-endpoint-sg-${var.environment}"
    Environment = var.environment
  }
}

# Create SSH key pair from provided public key
resource "aws_key_pair" "bastion" {
  key_name   = "bastion-key-${var.environment}"
  public_key = var.ssh_public_key

  tags = {
    Name        = "bastion-key-${var.environment}"
    Environment = var.environment
  }
}

# Create Security Group for Bastion Host
resource "aws_security_group" "bastion" {
  name        = "bastion-sg-${var.environment}"
  description = "Security group for bastion host"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "bastion-sg-${var.environment}"
    Environment = var.environment
  }
}

# Create Bastion Host in the first public subnet
resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.bastion_instance_type
  subnet_id                   = aws_subnet.public[0].id
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  key_name                    = aws_key_pair.bastion.key_name
  associate_public_ip_address = true

  tags = {
    Name        = "bastion-${var.environment}"
    Environment = var.environment
  }
}

# Data source for Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}