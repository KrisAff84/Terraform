# Description

Deploys an AWS auto scaling group spanning two public subnets in the Default VPC with an S3 bucket as backend. 

# Resources Created: 

* Launch Template with user data installed on instances (script works on RPM based AMIs)
* Autoscaling Group spanning two subnets
* Application load balancer 
* S3 Bucket
* IAM instance profile giving server instances bucket read/write access
* Security group for autoscaling group accepting HTTP traffic from load balancer
* Security group for load balancer - default is to allow all HTTP traffic 
* Random bucket name suffix generator

# Required Variables

* region
* ami
* instance_type
* key_name
* max_size
* min_size
* desired_capacity
