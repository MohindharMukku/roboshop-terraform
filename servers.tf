terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

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

output "ami_image_id" {
  value = data.aws_ami.centos.image_id
}

#-------------------------------------------
resource "aws_instance" "frontend" {
  ami           = data.aws_ami.centos.image_id
  instance_type = "t3.micro"

  tags = {
    Name = "frontend"
  }
}

resource "aws_route53_record" "frontend" {
  zone_id = "Z08053652T3ZYZGCDQNRV" # get the hosted zone ID from the route53
  name    = "frontend-dev.mohindhar.tech" # the dns record name should adhere to the naming rules for DNS records
  type    = "A"
  ttl     = 30
  records = [aws_instance.frontend.private_ip]
}

output "DNS_name" {
  value = aws_route53_record.frontend.name
}
#---------------------------------------------
resource "aws_instance" "mongodb" {
  ami           = data.aws_ami.centos.image_id
  instance_type = "t3.micro"

  tags = {
    Name = "mongodb"
  }
}

resource "aws_route53_record" "mongodb" {
  zone_id = "Z08053652T3ZYZGCDQNRV"
  name    = "mongodb-dev.mohindhar.tech" # the dns record name should adhere to the naming rules for DNS records
  type    = "A"
  ttl     = 30
  records = [aws_instance.mongodb.private_ip]
}
#---------------------------------------------

resource "aws_instance" "catalogue" {
  ami           = data.aws_ami.centos.image_id
  instance_type = "t3.micro"

  tags = {
    Name = "catalogue"
  }
}

resource "aws_route53_record" "catalogue" {
  zone_id = "Z08053652T3ZYZGCDQNRV"
  name    = "catalogue-dev.mohindhar.tech" # the dns record name should adhere to the naming rules for DNS records
  type    = "A"
  ttl     = 30
  records = [aws_instance.catalogue.private_ip]
}
#---------------------------------------------

resource "aws_instance" "redis" {
  ami           = data.aws_ami.centos.image_id
  instance_type = "t3.micro"

  tags = {
    Name = "redis"
  }
}

resource "aws_route53_record" "redis" {
  zone_id = "Z08053652T3ZYZGCDQNRV"
  name    = "redis-dev.mohindhar.tech" # the dns record name should adhere to the naming rules for DNS records
  type    = "A"
  ttl     = 30
  records = [aws_instance.redis.private_ip]
}
#---------------------------------------------

resource "aws_instance" "user" {
  ami           = data.aws_ami.centos.image_id
  instance_type = "t3.micro"

  tags = {
    Name = "user"
  }
}

resource "aws_route53_record" "user" {
  zone_id = "Z08053652T3ZYZGCDQNRV"
  name    = "user-dev.mohindhar.tech" # the dns record name should adhere to the naming rules for DNS records
  type    = "A"
  ttl     = 30
  records = [aws_instance.user.private_ip]
}
#---------------------------------------------
