locals {
  ingress_rules = {
    22   = ["203.0.113.10/32"]     # SSH only from office IP
    80   = ["0.0.0.0/0"]           # Public HTTP
    443  = ["0.0.0.0/0"]           # Public HTTPS
    8080 = ["10.0.0.0/16"]         # Internal apps
    9000 = ["192.168.1.0/24"]      # Monitoring subnet
  }
}
resource "aws_security_group" "devops_project" {
  name        = "devops-project-veera"
  description = "DevOps project SG"

  dynamic "ingress" {
    for_each = local.ingress_rules
    content {
      from_port   = ingress.key
      to_port     = ingress.key
      protocol    = "tcp"
      cidr_blocks = ingress.value
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops-project-veera"
  }
}
