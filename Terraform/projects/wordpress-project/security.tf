resource "aws_security_group" "SG" {
  name        = "EC2-SG"
  description = "Allow http traffic"

}

resource "aws_vpc_security_group_ingress_rule" "SG-rule-in" {
  security_group_id = aws_security_group.SG.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_egress_rule" "SG-rule-out" {
  security_group_id = aws_security_group.SG.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
 
}