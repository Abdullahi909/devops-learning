variable "instance_type" {
  type = string
}

locals {
  instance_ami = "ami-0b6d9d3d33ba97d99"
}

output "instance_id" {
  description = "The EC2 instance ID"
  value       = aws_instance.test.id
}
