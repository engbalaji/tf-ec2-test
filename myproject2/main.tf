provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "example1" {
  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id    = var.subnet1_id
  vpc_security_group_ids = [var.security_group1_id]
  
  tags = {
    Name = var.instance1_name
  }
}

resource "aws_instance" "example2" {
  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id    = var.subnet2_id
  vpc_security_group_ids = [var.security_group2_id]

  tags = {
    Name = var.instance2_name
  }
}
