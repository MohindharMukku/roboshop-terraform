terraform {
  backend "s3" {
    bucket = "devops-roboshop"
    key    = "robodhop/dev/terraform.tfstate"
    region = "us-east-1"
  }
}