variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "key_name" {
  description = "The name of the SSH key pair"
  type        = string
}

variable "db_name" {
  description = "The name of the WordPress database"
  type        = string
}

variable "db_user" {
  description = "The username for the WordPress database"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "The password for the WordPress database"
  type        = string
  sensitive   = true
}