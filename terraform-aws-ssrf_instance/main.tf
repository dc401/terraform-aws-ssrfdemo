#terraform-aws-ssrf_instance module main.tf

#reference adjacent module terraform-aws-ssrf_network for subnet and security group attachments to instance

data "aws_ami" "amazon-2" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  owners = ["amazon"]
}

#includes user data for demonstratable SSRF for IMDSv1
resource "aws_instance" "ssrf_demo_server" {
  ami           = data.aws_ami.amazon-2.id
  instance_type = "t2.micro"
  #Cannot reference the below because we did not instantiate the terraform-aws-ssrf_network module from within this one as a parent/child.
  #Declaration was at root main.tf which keeps the modules isolated. Use of outputs.tf and variablles.tf as inputs were used instead
  #vpc_security_group_ids      = [aws_security_group.ssrf_sg.id]
  #subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [var.vpc_security_group_ids]
  subnet_id                   = var.subnet_id
  user_data_replace_on_change = true
  user_data                   = file("ssrf_imdsv1_aws_demo.sh")
  tags = {
    Name        = "ssrf_demo_server"
    Environment = "demo"
  }
}