# Validation statements - a way of setting conditions on variables

variable "cloud" {
  type = string

  validation {
    condition     = contains(["aws", "azure", "gcp"], var.cloud)
    error_message = "Cloud must be either aws, azure, or gcp"
  }

  validation {
    condition     = lower(var.cloud) == var.cloud
    error_message = "Cloud name must be lowercase"
  }

  validation {
    condition     = length(var.cloud) >= 3 && length(var.cloud) <= 5
    error_message = "Cloud name must be at least 3 characters and no more than 5 characters"
  }
}

variable "ip_address" {
  type = string

  validation {
    condition     = can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$", var.ip_address))
    error_message = "IP address must be in the format of x.x.x.x"
  }
}

variable "phone_number" {
  type      = string
  sensitive = true
  default   = "867-5309"
}

locals {
  contact_info = {
    cloud        = var.cloud
    department   = var.department
    phone_number = var.phone_number
  }
  my_number = nonsensitive(var.phone_number)
}