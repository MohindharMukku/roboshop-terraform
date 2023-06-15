#terraform {
#  required_providers {
#    aws = {
#      source  = "hashicorp/aws"
#      version = "~> 5.0"
#    }
#  }
#}
##
## Configure the AWS Provider
#provider "aws" {
#  region = "us-east-1"
#}

#reperate this block for creating all the 10 instances

#-------------------------------------------
resource "aws_instance" "instances" {
  for_each = var.components
  ami           = data.aws_ami.centos.image_id
  instance_type = each.value["instance_type"]
  vpc_security_group_ids = [ data.aws_security_group.allow-all.id ]

  tags = {
    Name = "${each.value.name}_${var.env}"
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


