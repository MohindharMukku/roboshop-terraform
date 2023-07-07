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
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name

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

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.env}-${var.component_name}-role"
  role = aws_iam_role.role.name
}

resource "aws_iam_role_policy" "ssm-ps-policy" {
  name = "${var.env}-${var.component_name}-ssm-ps-policy"
  role = aws_iam_role.role.id
  
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
  {
    "Sid": "VisualEditor0",
    "Effect": "Allow",
    "Action": [
    "kms:Decrypt",
    "ssm:GetParameterHistory",
    "ssm:GetParametersByPath",
    "ssm:GetParameters",
    "ssm:GetParameter"
  ],
    "Resource": [
    "arn:aws:kms:us-east-1:655263643424:key/arn:aws:kms:us-east-1:655263643424:key/f4069cfc-ff14-4bf8-b002-0f5b56727881",
    "arn:aws:ssm:us-east-1:655263643424:parameter/${var.env}-${var.component_name}.*"
  ]
  }
  ]
  })
}