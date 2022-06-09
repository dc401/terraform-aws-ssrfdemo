#terraform-aws-ssrf_network module main.tf

#VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidir
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    "Name"        = var.vpc_name
    "Environment" = "demo"
  }
}

#IGW and Public Subnets
resource "aws_internet_gateway" "ssrf_igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name"        = "${var.vpc_name}-IGW"
    "Environment" = "demo"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.az_name
  tags = {
    "Name"        = var.subnet_name
    "Environment" = "demo"
  }
}

#Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ssrf_igw.id
  }
  tags = {
    "Name"        = "${var.vpc_name}-RT"
    "Environment" = "demo"
  }
}

#Associate Public Subnet with Route Table
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

#Security Group
resource "aws_security_group" "ssrf_sg" {
  vpc_id      = aws_vpc.vpc.id
  description = "SSRF Demo Security Group"
  ingress {
    description = "Allow HTTP inbound to SSRF vulnerable host"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "allow_http_inbound_ssrf_sg"
    Environment = "demo"
  }
}