resource "aws_instance" "wordpress_ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name

  user_data = templatefile("${path.module}/wp_rds_install.sh", {
    db_host     = var.db_host
    db_name     = var.db_name
    db_user     = var.db_user
    db_password = var.db_password
  })

  tags = {
    Name = "WordPress EC2 Instance"
  }
}

output "ec2_public_ip" {
  value = aws_instance.wordpress_ec2.public_ip
}