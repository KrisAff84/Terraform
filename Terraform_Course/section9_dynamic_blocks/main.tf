# A dynamic block is a container for nested blocks that can be
# arbitrarily repeated zero or more times within a root block.

locals {
  ingress_rules = [{
    port        = 443
    description = "TLS from internet"
    },
    {
      port        = 80
      description = "HTTP from internet"
  }]
}

resource "aws_security_group" "main" {
  name        = "main_sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = local.ingress_rules
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

# Overuse of dynamic blocks can make configuration hard to read and maintain.
# If you find yourself using a dynamic block with only one nested block,
# consider using a for expression instead.

