# To create an environment variable
# export TV_VAR_<variable_name>=<variable_value>
# export TF_VAR_region=us-east-1 (In command line)

# Most popular way to set variables is through .tfvars file

# Can also assign values to variables during terraform plan/apply
# terraform plan -var variables_<variable_name>=<variable_value>
# terraform apply -var variables_<variable_name>=<variable_value>
