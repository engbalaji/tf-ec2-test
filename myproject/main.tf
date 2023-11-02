
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}

resource "aws_vpc" "vpc-b30658d4" {
  cidr_block = "10.254.0.0/20"
}

resource "aws_internet_gateway" "my-igw" {
  vpc_id = "${aws_vpc.vpc-b30658d4.id}"
}

resource "aws_route" "internet-access" {
  route_table_id = "${aws_vpc.vpc-b30658d4.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.my-igw.id}"
}

resource "aws_subnet" "my-sub" {
  vpc_id = "${aws_vpc.vpc-b30658d4.id}"
  cidr_block = "192.168.1.0/24"
  map_public_ip_on_launch = "true"
}

resource "aws_security_group" "elb-sg" {
  name = "my-elb-sg"
  vpc_id = "${aws_vpc.vpc-b30658d4.id}"
  ingress {
    from_port = 80
    to_port = 80
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

resource "aws_security_group" "ec2-sg" {
  name = "bm-ec2-ss-sg"
  vpc_id = "${aws_vpc.vpc-b30658d4.id}"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["192.168.0.0/16"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my-instance" {
  instance_type = "t2.micro"
  ami = "${lookup(var.amis, var.region)}"
  vpc_security_group_ids = ["${aws_security_group.ec2-sg.id}"]
  subnet_id = "${aws_subnet.my-sub.id}"
}
