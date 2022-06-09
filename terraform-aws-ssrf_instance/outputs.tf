#outputs for terraform-aws-ssrf_instance module
output "instance_id" {
  value = aws_instance.ssrf_demo_server.id
}
output "instance_ip" {
  value = aws_instance.ssrf_demo_server.public_ip
}
output "instance_dns" {
  value = aws_instance.ssrf_demo_server.public_dns
}