variable "env" {} # here the variable "env" is assigning the env value from the main.tfvars, main.tfvars > vars.tf > servers.tf
variable "instance_type" {}
variable "component_name" {}
variable "password" {}
variable "provisioner" {
  default = false
}
variable "app_type" {}

