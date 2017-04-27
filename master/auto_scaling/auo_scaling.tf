resource "aws_autoscaling_group" "master_asg" {
  lifecycle { create_before_destroy = true }
  vpc_zone_identifier = ["${var.master_subnet_id}"]
  name = "dcos-master-autoscaling-group"
  max_size = "${var.asg_max}"
  min_size = "${var.asg_min}"
  wait_for_elb_capacity = false
  force_delete = true
  launch_configuration = "${var.master_lc_id}"
  load_balancers = ["${var.master_elb_name}"]
  tag {
    key = "Name"
    value = "${var.project-tag}-master"
    propagate_at_launch = "true"
  }
}
