provider "aws" {

region = "us-east-1" # Replace with your preferred region

}
resource "aws_vpc" "my_vpc" {

cidr_block = "10.0.0.0/16"

}

resource "aws_subnet" "my_subnet" {

vpc_id = aws_vpc.my_vpc.id

cidr_block = "10.0.1.0/24"

availability_zone = "us-east-1a" # Adjust the availability zone

}
resource "aws_security_group" "web_server_sg" {

name = "allow_web_traffic"

vpc_id = aws_vpc.my_vpc.id

ingress {

from_port = 80

to_port = 80

protocol = "tcp"

cidr_blocks = ["0.0.0.0/0"]

}

ingress {

from_port = 443

to_port = 443

protocol = "tcp"

cidr_blocks = ["0.0.0.0/0"]

}

egress {

from_port = 0

to_port = 0

protocol = "-1"

cidr_blocks = ["0.0.0.0/0"]

    }
}

resource "aws_instance" "web_server" {
  ami           = "ami-0c101f26f147fa7fd"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_subnet.id  # Use the ID of your subnet here
  vpc_security_group_ids = [aws_security_group.web_server_sg.id]  # Use the ID of your security group here

  # Other configuration parameters for your EC2 instance

user_data = <<-EOF

#!/bin/bash

yum update -y # Or apt-get update -y for Ubuntu

yum install httpd -y # Or apt-get install apache2 -y

systemctl start httpd

systemctl enable httpd

echo "<h1>Hello from Terraform!</h1>" > /var/www/html/ 

EOF

}