variable "region_name" {
  description = "Human friendly name for AWS Regions e.g. us-east-1"
  type        = string
  default     = "us-east-1"
}

#grab the latest ami based on region for amz linux 2
#aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 --region us-east-1 
variable "ami_id" {
  description = "AMI ID for the intended demo image per region"
  type        = string
  default     = "ami-06eecef118bbf9259"
}

#name the ec2 instance something
variable "instance_name_prefix" {
  description = "EC2 instance name prefix"
  type        = string
  default     = "demo_ssrf_imdsv1"
}

#vpc friendly name and subnet details
variable "vpc_name" {
  description = "VPC name label"
  type        = string
  default     = "ssrf_demo_vpc"
}

variable "subnet_name" {
  description = "Subnet name label"
  type        = string
  default     = "public_subnet"
}

variable "vpc_dir" {
  description = "IP block for the VPC in IPv4 CIDR notation"
  type        = string
  default     = "192.168.0.0/16"
}