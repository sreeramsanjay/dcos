terraform {
  backend "s3" {
    bucket = "aa-tf-status"
    key    = "iaas-pilot/dcos-master.tfstatus"
    region = "us-east-1"
  }
}
provider "aws" {
  region = "${var.region}"
}
module "ec2_profile" {
  source = "../../dcos/master/ec2_profile"
}
module "security_groups" {
  source = "../../dcos/master/sg_dcos"
  vpc_id = "${var.vpc_id}"
  vpc_cidr = "${var.vpc_cidr}"
  project_tag = "${var.project_tag}"
}
module "launch_configurations" {
  source = "../../dcos/master/launch_config"
  centos_base_ami = "${var.centos_base_ami}"
  instance_type = "${var.instance_type}"
  dcos_master_security_group_id = "{module.security_groups.dcos_master_security_group_id}"
  mgmt_security_group_id = "{var.mgmt_security_group_id}"
  dcos_master_ec2_instance_profile = "{module.ec2_profile.dcos_master_ec2_instance_profile}"
  ssh_key_name = "${var.ssh_key_name}"
}
module "load_balancers" {
  source = "../../dcos/master/elb/"
  master_subnet_id = "${var.master_subnet_id}"
  master_elb_sg = "${module.security_groups.elb_security_group_id}"
}
module "autoscaling_groups" {
  source = "../master/auto_scaling/"
  project_tag = "${var.project_tag}"
  master_subnet_id = "${var.master_subnet_id}"
  master_lc_id = "${module.launch_configurations.master_lc_id}"
  master_lc_name = "${module.launch_configurations.master_lc_name}"
  master_elb_name = "${module.load_balancers.master_elb_name}"
}

#output "master_elb_dns_name" {
#  value = "${module.load_balancers}"
