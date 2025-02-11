variable "db_name" {
  description = "The name of the WordPress database"
  type        = string
}

variable "db_user" {
  description = "The username for the WordPress database"
  type        = string
}

variable "db_password" {
  description = "The password for the WordPress database"
  type        = string
  sensitive   = true
}

variable "subnet_ids" {
  description = "List of subnet IDs for the RDS instance"
  type        = list(string)
}

variable "security_group_id" {
  description = "The ID of the security group to attach to the RDS instance"
  type        = string
}