#reperate this block for creating all the 10 instances
data "aws_ami" "centos" {
  owners = ["973714476881"]
  most_recent = true
  name_regex = "Centos-8-DevOps-practice"
}

output "ami_id" {
  value = data.aws_ami.centos.image_id
}


#resource "aws_instance" "frontend" {
#  ami           = "ami-0b5a2b5b8f2be4ec2"
#  instance_type = "t3.micro"
#
#  tags = {
#    Name = "frontend"
#  }
#}
#
#resource "aws_instance" "mongodb" {
#  ami           = "ami-0b5a2b5b8f2be4ec2"
#  instance_type = "t3.micro"
#
#  tags = {
#    Name = "mongodb"
#  }
#}
##reperate this block for creating all the 10 instances
#resource "aws_instance" "catalogue" {
#  ami           = "ami-0b5a2b5b8f2be4ec2"
#  instance_type = "t3.micro"
#
#  tags = {
#    Name = "catalogue"
#  }
#}
#
#resource "aws_instance" "redis" {
#  ami           = "ami-0b5a2b5b8f2be4ec2"
#  instance_type = "t3.micro"
#
#  tags = {
#    Name = "redis"
#  }
#}
##reperate this block for creating all the 10 instances
#resource "aws_instance" "user" {
#  ami           = "ami-0b5a2b5b8f2be4ec2"
#  instance_type = "t3.micro"
#
#  tags = {
#    Name = "user"
#  }
#}
