
output "instance_id" {
  description = "The id of the instance"
  value = aws_instance.wordpress-server.id
}

output "public_ip" {
    description = "Public IP of instance"
    value = aws_instance.wordpress-server.public_ip
  
}