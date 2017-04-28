variable "asg_min" {
  default = "3"
}
variable "asg_max" {
  default = "3"
}
variable "master_subnet_id" { type = "list" }
variable "master_lc_id" {}
variable "master_lc_name" {}
variable "master_elb_name" {}
variable "project_tag" {}
