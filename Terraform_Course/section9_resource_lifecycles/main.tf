# create_before_destroy
# Terraform's default for replacing resources is to first destroy the old resource and then create the new one.
# Sometimes we need to alter this behavior. 
# For example, if we are making a change to a security group that is attached to an EC2 instance,
# an apply will fail because the EC2 instance has a dependency on the security group.

# To remedy use a lifecycle block with create_before_destroy set to true.

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  lifecycle {
    create_before_destroy = true
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }
}

# Other lifecycle options include:
# prevent_destroy - Prevents a resource from being destroyed.