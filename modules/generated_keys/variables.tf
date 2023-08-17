variable "region" {
  type = string
}
variable "key_name" {
  type = string
}
variable "path" {
  description = "The desired path to store private key"
  type        = string
  default     = "./"
}
variable "tags" {
  type    = map(any)
  default = null
}
