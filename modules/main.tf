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
#  for_each = var.component_name
  ami           = data.aws_ami.centos.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = [ data.aws_security_group.allow-all.id ]

  tags = {
    Name = local.name
  }
}

####
resource "null_resource" "provisioner" {
#  count = var.provisioner ? 1 : 0
  depends_on = [aws_instance.instances, aws_route53_record.records]
  provisioner "remote-exec" {
    
    connection {
      type = "ssh"
      user = "centos"
      password = "DevOps321"
      host = aws_instance.instances.private_ip
    }
    
    inline = var.app_type == "db" ? local.db_commands : local.app_commands
  }
}



resource "aws_route53_record" "records" {
  zone_id = "Z08053652T3ZYZGCDQNRV" # get the hosted zone ID from the route53
  name    =  "${var.component_name}-${var.env}.mohindhar.tech" # the dns record name should adhere to the naming rules for DNS records
  type    = "A"
  ttl     = 30
  records = [aws_instance.instances.private_ip]
}

resource "aws_iam_role" "role" {
  name = "${var.env}-${var.component_name}-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  
  tags = {
    tag-key = "${var.env}-${var.component_name}-role"
  }
}