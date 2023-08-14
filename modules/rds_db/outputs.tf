output "db_address" {
  value = aws_db_instance.default.address
}
output "db_port" {
  value = aws_db_instance.default.port
}
output "db_identifier" {
  value = aws_db_instance.default.id
}
output "db_username" {
  value = aws_db_instance.default.username
}
output "db_password" {
  value = aws_db_instance.default.password
  sensitive = true
}
output "db_security_group_id" {
  value = aws_security_group.db_access.id
}
output "db_subnet_group_id" {
  value = aws_db_subnet_group.default.id
}
output "db_subnet_group_name" {
  value = aws_db_subnet_group.default.name
}
output "db_subnet_group_arn" {
  value = aws_db_subnet_group.default.arn
}
output "db_subnet_group_vpc_id" {
  value = aws_db_subnet_group.default.vpc_id
}