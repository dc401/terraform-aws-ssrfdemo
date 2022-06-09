#terraform-aws-ssrf_network module variables
variable "region_name" {
  description = "Human friendly name for AWS Regions e.g. us-east-1"
  type        = string
  default     = "us-east-1"
}

variable "az_name" {
  description = "Human friendly name for AWS Availability Zones e.g. us-east-1a"
  type        = string
  default     = "us-east-1a"
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

variable "vpc_cidir" {
  description = "IP block for the VPC in IPv4 CIDR notation"
  type        = string
  default     = "192.168.0.0/16"
}

variable "public_subnet_cidr" {
  description = "IP block for the public subnet in IPv4 CIDR notation"
  type        = string
  default     = "192.168.100.0/24"
}