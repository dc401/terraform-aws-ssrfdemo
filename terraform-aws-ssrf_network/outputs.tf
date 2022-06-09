output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "public_subnet_cidr" {
  value = aws_subnet.public_subnet.cidr_block
}

output "aws_internet_gateway_id" {
  value = aws_internet_gateway.ssrf_igw.id
}

output "aws_route_table_id" {
  value = aws_route_table.public_rt.id
}

#These outputs below are required for the ssrm instance module
output "vpc_security_group_ids" {
  value = aws_security_group.ssrf_sg.id
}

output "subnet_id" {
  value = aws_subnet.public_subnet.id
}