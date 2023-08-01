resource "aws_launch_template" "asg_web_lt" {
  name          = "asg_web_lt"
  image_id      = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [
    aws_security_group.asg_web_access_sg.id,
    aws_security_group.asg_ssh_access_sg.id
  ]
  # iam_instance_profile {
  #   name = "test"
  # }
  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd
EOF
  )
}

# resource "aws_autoscaling_group" "bar" {
#   name                = "asg_asg"
#   max_size            = 5
#   min_size            = 2       
#   health_check_type   = "ELB"
#   desired_capacity    = 2
#   launch_template     = aws_launch_template.asg_web_lt.name
#   vpc_zone_identifier = [aws_subnet.example1.id, aws_subnet.example2.id]
# }
