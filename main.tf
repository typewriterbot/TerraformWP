terraform {
  backend "s3" {
    bucket         = "swen614-terraform-bucket-test2"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"  # Set AWS region to US East 1 (N. Virginia)
}

# Local variables block for configuration values
locals {
    aws_key = "AWSEAST"   # SSH key pair name for EC2 instance access
}
# Security Group to allow HTTP and SSH accesss
resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP and SSH traffic"
  
  # Allow HTTP (port 80) for WordPress
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
         from_port   = 0
             to_port     = 0
                 protocol    = "-1"
                     cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 instance resource definition
resource "aws_instance" "my_server" {
   ami           = data.aws_ami.amazonlinux.id  # Use the AMI ID from the data source
   instance_type = var.instance_type            # Use the instance type from variables
   key_name      = "${local.aws_key}"          # Specify the SSH key pair name
   
   security_groups = [aws_security_group.allow_http.name]
   
   user_data = file("${path.module}/wp_install.sh")

   # Add tags to the EC2 instance for identification
   tags = {
     Name = "my ec2"
   }                  
}
