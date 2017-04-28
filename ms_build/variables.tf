variable "region" {
  default = "us-east-1"
}
variable "vpc_id" {
  default = "vpc-c8a4b3ae"
}
variable "vpc_cidr" {
  default = "10.220.16.0/22"
}
variable "ssh_source_cidr_block" {
  default = "1.1.1.6/32"
}
variable "availability_zones" {
  type = "list"
  default = ["us-east-1c", "us-east-1d"]
}
variable "master_subnet_id" {
  type = "list"
  default = ["subnet-87fb20cf", "subnet-fdb552a7"]
}
variable "centos_base_ami" {
  default = "ami-47096750"
}
variable "project_tag" {
  default = "IaaS-Pilot"
}
variable "ssh_key_name" {
  default = "RACONAWS"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "mgmt_security_group_id" {
 default = "sg-c60c33b9"
}
