provider "aws" {
  region = "ap-south-1"
}

variable "vpc_cidr_blocks" {}

variable "subnet_cidr_blocks" {}

variable "avail_zone" {}

variable "env_prefix" {}

variable "my-ip" {}

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

resource "aws_route_table" "my-route-table" {
  vpc_id = aws_vpc.my_vpc.id
  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-gateway.id
  } 

  tags = {
    Name : "${var.env_prefix}-route-table"
  }
}

resource "aws_internet_gateway" "my-gateway" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name : "${var.env_prefix}-internet-gateway"
  }

}

resource "aws_route_table_association" "association-route-table" {
    subnet_id = aws_subnet.my_subnet1.id
    route_table_id = aws_route_table.my-route-table.id
}

resource "aws_security_group" "my-sg" {
    name="myapp-sg"
    vpc_id = aws_vpc.my_vpc.id
    ingress{
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.my-ip]
    }

     ingress{
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        prefix_list_ids = []
    }

    tags = {
    Name : "${var.env_prefix}-sg"
  }
}

data "aws_ami" "amazon-latest-ami-image" {
    most_recent = true
    owners = ["amazon"]
    filter {
        name ="name"
        values =["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
    }

}

output "aws-ami" {
    value = data.aws_ami.amazon-latest-ami-image.id
}

resource "aws_instance" "web-server" {
  ami = data.aws_ami.amazon-latest-ami-image.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.my_subnet1.id
  vpc_security_group_ids = [aws_security_group.my-sg.id]
  availability_zone = var.avail_zone
  associate_public_ip_address = true
  key_name = "mayank"

  user_data = <<EOF
               #!/bin/bash
               sudo yum update -y && sudo yum install -y docker
               sudo systemctl start docker
               sudo usermod -aG docker ec2-user
               docker run -p 8080:80 nginx

              EOF
   tags = {
    Name : "${var.env_prefix}-server"
  }
}
