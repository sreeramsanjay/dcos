resource "aws_elb" "master_elb" {
  name = "dcos"
  subnets = ["${var.master_subnet_id}"]
  listener {
    instance_port = 5050
    instance_protocol = "http"
    lb_port = 5050
    lb_protocol = "http"
  }
  listener {
    instance_port = 2181
    instance_protocol = "tcp"
    lb_port = 2181
    lb_protocol = "tcp"
  }
  listener {
    instance_port = 8181
    instance_protocol = "http"
    lb_port = 8181
    lb_protocol = "http"
  }
  listener {
    instance_port = 80
    instance_protocol = "tcp"
    lb_port = 80
    lb_protocol = "tcp"
  }
  listener {
    instance_port = 443
    instance_protocol = "tcp"
    lb_port = 443
    lb_protocol = "tcp"
  }
  listener {
    instance_port = 8080
    instance_protocol = "http"
    lb_port = 8080
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 5
    target = "TCP:5050"
    interval = 30
  }
  security_groups = ["${var.master_elb_sg}"]
  tags {
      Name = "dcos_master_elb"
  }
}
output "master_elb_name" {
  value = "${aws_elb.master_elb.name}"
}
