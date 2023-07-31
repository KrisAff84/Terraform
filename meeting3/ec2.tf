resource "aws_instance" "MyWeb" {
  ami           = var.ami
  instance_type = var.instance
  count         = "1"
  key_name      = var.key
  security_groups = [
    aws_security_group.ssh_access.name,
    aws_security_group.web_access.name
  ]
  tags = {
    Name = "HelloWorld"
  }
}