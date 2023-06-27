locals {
  name = var.env != "" ? "${var.env}-${var.component_name}" : var.component_name
}