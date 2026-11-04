resource "aws_security_group" "ec2" {
  # name_prefix (not name) so a replacement can create the new group before
  # destroying the old one. A fixed name would collide during that window.
  name_prefix = "${var.security_group_name}-"
  description = "Security group for EC2 instances"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = var.security_group_name
  }
}

# Rules are discrete resources rather than inline ingress/egress blocks: one
# rule can change without the provider diffing the whole group, and each rule
# carries its own description in the console.

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  for_each = toset(var.ssh_cidrs)

  security_group_id = aws_security_group.ec2.id
  description       = "SSH from trusted IP ${each.value}"
  cidr_ipv4         = each.value
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.ec2.id
  description       = "HTTP from anywhere"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  count = var.enable_https ? 1 : 0

  security_group_id = aws_security_group.ec2.id
  description       = "HTTPS from anywhere"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "all_ipv4" {
  security_group_id = aws_security_group.ec2.id
  description       = "Allow outbound IPv4 traffic"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
