provider "aws" {
  region = "ap-south-1"
}

variable "vpc_cidr_blocks" {}

variable "subnet_cidr_blocks" {}

variable "avail_zone" {}

variable "env_prefix" {}

resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr_blocks
  tags = {
    Name : "${var.env_prefix}-vpc"
  }
}

resource "aws_subnet" "my_subnet1" {
  cidr_block        = var.subnet_cidr_blocks
  vpc_id            = aws_vpc.my_vpc.id
  availability_zone = var.avail_zone
  tags = {
    Name : "${var.env_prefix}-subnet-1"
  }
}
