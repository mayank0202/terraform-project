provider "aws" {
  region = "ap-south-1"
}



resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr_blocks
  tags = {
    Name : "${var.env_prefix}-vpc"
  }
}

module "subnet-module" {
  source = "./modules/subnet"
  subnet_cidr_blocks = var.subnet_cidr_blocks
  avail_zone =var.avail_zone
  env_prefix =var.env_prefix
  vpc_id = aws_vpc.my_vpc.id
}

module "webserver-module" {
  source = "./modules/webserver"
  vpc_id = aws_vpc.my_vpc.id
 image-name = var.image-name
 my-ip = var.my-ip
 env_prefix = var.env_prefix
 subnet_id = module.subnet-module.subnet.id
avail_zone = var.avail_zone
  
}

resource "aws_route_table_association" "association-route-table" {
    subnet_id = module.subnet-module.subnet.id
    route_table_id = module.subnet-module.route-table.id
}

