# Can define a list of locals variables in the following way:

locals {
  common_tags = {
    Name = "MyName"
    Owner = "Me"
    Service = "WebService"
    App = "MyApp"
  }
}
# In addition to strings, expressions can be used to define locals.

# Then common_tags can be assigned to tags section of any resource

# Example:

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  tags = local.common_tags
}