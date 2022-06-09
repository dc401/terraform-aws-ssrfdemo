#terraform-aws-ssrf_instance module variables

#declare dependency variables from terraform_aws_ssrf_network module as input
variable "vpc_security_group_ids" {
  type = string
}
variable "subnet_id" {
  type = string
}

