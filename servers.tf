terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
#
# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

#reperate this block for creating all the 10 instances
data "aws_ami" "centos" {
  owners      = ["973714476881"]
  most_recent = true
  name_regex  = "Centos-8-DevOps-Practice" # ami name should be same as the image name
}

data "aws_security_group" "allow-all" {
  name = "allow-all"
}

variable "components" {
  default = {
    frontend = {
      name = "frontend"
      instance_type = "t3.small"
    }
    mongodb = {
      name = "mongodb"
      instance_type = "t3.small"
    }
    catalogue = {
      name = "catalogue"
      instance_type = "t3.small"
    }
    redis = {
      name = "redis"
      instance_type = "t3.small"
    }
    user = {
      name = "user"
      instance_type = "t3.small"
    }
  }
  
}
#-------------------------------------------
resource "aws_instance" "instances" {
  for_each = var.components
  ami           = data.aws_ami.centos.image_id
  instance_type = each.value["instance_type"]
  vpc_security_group_ids = [ data.aws_security_group.allow-all.id ]

  tags = {
    Name = each.value["name"]
  }
}

####

# resource "aws_route53_record" "frontend" {
#   zone_id = "Z08053652T3ZYZGCDQNRV" # get the hosted zone ID from the route53
#   name    = "frontend-dev.mohindhar.tech" # the dns record name should adhere to the naming rules for DNS records
#   type    = "A"
#   ttl     = 30
#   records = [aws_instance.frontend.private_ip]
# }

# output "DNS_name" {
#   value = aws_route53_record.frontend.name
# }
#---------------------------------------------


