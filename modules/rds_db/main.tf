terraform {
  required_version = "~> 1.5.3"
  required_providers {
    aws = {
      version = "~> 5.10.0"
    }
  }
}
provider "aws" {
  region = var.region
}

resource "aws_db_instance" "default" {
  db_name              = var.db_name
  apply_immediately    = var.apply_immediately
  multi_az             = var.multi_az
  auto_minor_version_upgrade = var.minor_version_upgrade
  db_subnet_group_name = var.subnet_group
  allocated_storage    = var.storage
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  name                 = var.name
  username             = var.username
  password             = var.password
  parameter_group_name = var.parameter_group_name
  skip_final_snapshot  = var.skip_final_snapshot
  vpc_security_group_ids = [
    aws_security_group.db_access.id
  ]
  tags = {
    Name = var.name
  }
}

resource "aws_security_group" "db_access" {
  name        = "db_access"
  description = "Allow access to the database"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.from_port_1
    to_port     = var.to_port_1
    protocol    = var.protocol_1
    cidr_blocks = [var.cidr_block_1]
  }

  ingress {
    from_port   = var.from_port_2
    to_port     = var.to_port_2
    protocol    = var.protocol_2
    cidr_blocks = [var.cidr_block_2]
  }

  egress {
    from_port   = var.from_port_1
    to_port     = var.to_port_1
    protocol    = var.protocol_1
    cidr_blocks = [var.cidr_block_1]
  }

  egress {
    from_port   = var.from_port_2
    to_port     = var.to_port_2
    protocol    = var.protocol_2
    cidr_blocks = [var.cidr_block_2]
  }
}