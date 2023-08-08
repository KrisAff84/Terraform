Still testing the functionality of this module. Trying to figure out how to make subnet IDs from default VPC a default, but also allow different subnets to be passed as variables. Currently implemented assigning subnets to a local, then using the try function to try variable value first then using local value. Did not work. 

# Update #1
This method works

Define subnet IDs as locals and then pass in below argument. If variable value contains an empty string then use data source. Just need to fill out for the rest of the areas needing subnet IDs.

subnet_id1 = var.asg_subnet_id_1 != "" ? var.asg_subnet_id_1 : data.aws_subnets.default.ids[0]

