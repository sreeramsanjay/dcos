terraform {
  backend "s3" {
    bucket = "aa-tf-status"
    key    = "iaas-pilot/dcos-bs.tfstatus"
    region = "us-east-1"
  }
}
provider "aws" {
  region = "${var.region}"
}
module "sg_mgmt" {
  source = "../bootstap/sg_mgmt"
  vpc_id = "${var.vpc_id}"
  project_tag = "${var.project_tag}"
  vpc_cidr = "${var.vpc_cidr}"
  ssh_source_cidr_block = "${var.ssh_source_cidr_block}"
}
module "s3_bucket" {
  source = "../bootstap/s3_bucket"
  bucket_name = "${var.bucket_name}"
  project_tag = "${var.project_tag}"
}
module "bs_node" {
  source = "../bootstap/ec2_instance"
  project_tag = "${var.project_tag}"
  #bs_s3_bucket = "${module.s3_bucket.bs_bucket_name}"
  instance_type = "${var.instance_type}"
  centos_base_ami = "${var.centos_base_ami}"
  node_name = "${var.node_name}"
  sec_grp_list = "${module.sg_mgmt.mgmt_security_group_id}"
  ssh_key_name = "${var.ssh_key_name}"
  private_subnet_id = "${var.private_subnet_id}"
}

