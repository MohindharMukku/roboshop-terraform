terraform {
  backend "s3" {
    bucket = "devops-roboshop"
    key    = "robodhop/test/terraform.tfstate"
    region = "us-east-1"
  }
}