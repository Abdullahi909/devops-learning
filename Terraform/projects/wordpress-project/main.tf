resource "aws_instance" "wordpress-server" {
  ami           = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = [ aws_security_group.SG.id ]
  user_data = file("${path.module}/cloud-init.yaml")
  user_data_replace_on_change = true
  tags = {
    Name = "web-server-wordpress"
  }
}