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
#resource "aws_instance" "instances" {
#  for_each = var.components
#  ami           = data.aws_ami.centos.image_id
#  instance_type = each.value["instance_type"]
#  vpc_security_group_ids = [ data.aws_security_group.allow-all.id ]
#
#  tags = {
#    Name = "${var.env}-${each.value.["name"]}"
#  }
#}
#
#####
#
# resource "aws_route53_record" "records" {
#   for_each = var.components
#   zone_id = "Z08053652T3ZYZGCDQNRV" # get the hosted zone ID from the route53
#   name    =  "${each.value.["name"]}-${var.env}.mohindhar.tech" # the dns record name should adhere to the naming rules for DNS records
#   type    = "A"
#   ttl     = 30
#   records = [aws_instance.instances.private_ip]
# }


#---------------------------------------------

module "database-servers" {
  for_each       = var.database_servers
  source         = "./module"
  component_name = each.value["name"]
  env            = var.env
  instance_type  = each.value["instance_type"]
  password       = lookup(each.value, "password", "null")
  provisioner      = true
}

module "app-servers" {
  depends_on = [module.database-servers]
  for_each        = var.apps_servers
  source          = "./module"
  component_name  = each.value["name"]
  env             = var.env
  instance_type   = each.value["instance_type"]
  password        = lookup(each.value, "password" , "null")
}