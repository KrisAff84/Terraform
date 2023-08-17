module "keys" {
  source = "../modules/generated_keys"

  region   = "us-east-2"
  key_name = "TestKey"
  tags = {
    Environment = "Terrform Modules Test"
    Department  = "DevSecOps"
  }
}
output "arn" {
  value = module.keys.arn
}
output "key_type" {
  value = module.keys.key_type
}
output "tags" {
  value = module.keys.tags
}