variable "phone_number" {
  type      = string
  sensitive = true
}

# In outputs.tf
# Adding sensitive = true to the output will prevent the value from being displayed in the output

output "phone_number" {
  value     = var.phone_number
  sensitive = true
}

# We don't even want sensitive values in the variables file, so another way of doing this
# is to set environment variables and then reference them in the variables file

# # export TF_VAR_phone_number=867-5309

# Also checkout HshiCorp Vault for storing sensitive values

# Once vault is set up you can use data sources to retrieve the values from vault
# https://www.vaultproject.io/docs/providers/aws

data "vault_generic_secret" "phone_number" {
  path = "secret/data/phone_number"
}


