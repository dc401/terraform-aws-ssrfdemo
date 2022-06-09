terraform {
  required_version = ">= 1.2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  cloud {
    organization = "xtecsystems"
    workspaces {
      name = "test"
    }
  }
}

provider "aws" {
  region = var.region_name
}


#creates a new VPC with a public subnet and IGW attached
#default route to internet and SG allowing HTTP ingress
module "ssrf_network" {
  source = "./terraform-aws-ssrf_network"
}



#deploys a single EC2 t2 micro on AMz Linux 2 AMI
#with a public DNS name and public IP
#user data references local file bash script from ssrf_imdsv1_aws_demo.sh
module "ssrf_instance" {
  source = "./terraform-aws-ssrf_instance"
  #add argument of using output from ssrf_network module to use as input to variables.tf to this module from outputs.tf of ssrf_network module
  vpc_security_group_ids = module.ssrf_network.vpc_security_group_ids
  subnet_id              = module.ssrf_network.subnet_id
}

