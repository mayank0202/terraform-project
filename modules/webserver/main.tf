resource "aws_security_group" "my-sg" {
    name="myapp-sg"
    vpc_id = var.vpc_id
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
        values =[var.image-name]
    }

}

resource "aws_instance" "web-server" {
  ami = data.aws_ami.amazon-latest-ami-image.id
  instance_type = "t2.micro"
  subnet_id = var.subnet_id
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