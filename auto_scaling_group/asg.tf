resource "aws_launch_template" "asg_web_lt" {
  name = "asg_web_lt"
  image_id = var.ami
  # iam_instance_profile {
  #   name = "test"
  # }

}

# resource "aws_autoscaling_group" "bar" {
#   name                = "asg_asg"
#   max_size            = 5
#   min_size            = 2
#   health_check_type   = "ELB"
#   desired_capacity    = 2
#   launch_template     = aws_launch_template.asg_launch_template.name
#   vpc_zone_identifier = [aws_subnet.example1.id, aws_subnet.example2.id]
# }

# resource "aws_launch_template" "asg_launch_template" {
#   name_prefix   = "asg"
#   image_id      = var.ami
#   instance_type = var.instance_type
# }