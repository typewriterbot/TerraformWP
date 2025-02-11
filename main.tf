terraform {
  backend "s3" {
    bucket         = "swen614-terraform-bucket-test2"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
  vpc_name = "WordPress VPC"
}

module "subnets" {
  source = "./modules/subnets"
  vpc_id = module.vpc.vpc_id
  public_subnet_cidr = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
  availability_zones = ["us-east-1a", "us-east-1b"]
}

module "internet_gateway" {
  source           = "./modules/internet_gateway"
  vpc_id           = module.vpc.vpc_id
  public_subnet_id = module.subnets.public_subnet_id
}

module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source = "./modules/ec2"
  ami_id = data.aws_ami.amazon_linux_2023.id
  instance_type = "t2.micro"
  subnet_id = module.subnets.public_subnet_id
  security_group_id = module.security_groups.ec2_sg_id
  key_name = var.key_name
  db_host = module.rds.rds_endpoint
  db_name = var.db_name
  db_user = var.db_user
  db_password = var.db_password
}

module "rds" {
  source = "./modules/rds"
  db_name = var.db_name
  db_user = var.db_user
  db_password = var.db_password
  subnet_ids = [module.subnets.private_subnet_id, module.subnets.public_subnet_id]
  security_group_id = module.security_groups.rds_sg_id
}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

output "ec2_public_ip" {
  value = module.ec2.ec2_public_ip
}

output "rds_endpoint" {
  value = module.rds.rds_endpoint
}