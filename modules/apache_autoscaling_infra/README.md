# Description

Deploys an AWS auto scaling group spanning two public subnets in the Default VPC

# Resources Created: 

* Launch Template with user data installed on instances (script works on RPM based AMIs)
* Autoscaling Group spanning two subnets
* Application load balancer 
* Security group for autoscaling group accepting HTTP traffic from load balancer
* Security group for load balancer - default is to allow all HTTP traffic 

# Required Variables

* region
* ami
* instance_type
* key_name
* max_size
* min_size
* desired_capacity
