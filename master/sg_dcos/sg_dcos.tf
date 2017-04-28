resource "aws_security_group" "master_security_group" {
    name = "${var.project_tag}-master-sg"
    description = "dcos master access"
    vpc_id = "${var.vpc_id}"

#allows all outbound traffic
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

#allows traffic from the SG itself
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        self = true
    }

}
resource "aws_security_group" "elb_security_group" {
    name = "${var.project_tag}-master-elb-sg"
    description = "dcos master access"
    vpc_id = "${var.vpc_id}"

#allows all outbound traffic
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

#allows traffic from the SG itself
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

}
output "dcos_master_security_group_id" {
  value = "${aws_security_group.master_security_group.id}"
}

output "elb_security_group_id" {
  value = "${aws_security_group.elb_security_group.id}"
}

#dcos private agent security group
resource "aws_security_group" "priv_security_group" {
    name = "${var.project_tag}-priv-agent-sg"
    description = "dcos private agent access"
    vpc_id = "${var.vpc_id}"

#allows all outbound traffic
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

#allows traffic from the SG itself
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        self = true
    }

}

output "dcos_priv_security_group_id" {
  value = "${aws_security_group.priv_security_group.id}"
}


#dcos public agent security group
resource "aws_security_group" "pub_security_group" {
    name = "${var.project_tag}-dcos-pub-agent-sg"
    description = "dcos public agent access"
    vpc_id = "${var.vpc_id}"

#allows all outbound traffic
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

#allows traffic from the SG itself
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        self = true
    }
}

output "pub_agent_security_group_id" {
  value = "${aws_security_group.pub_security_group.id}"
}

resource "aws_security_group_rule" "master_priv_access" {
  depends_on	  = ["aws_security_group.priv_security_group", "aws_security_group.pub_security_group", "aws_security_group.master_security_group"]
  type            = "ingress"
  from_port       = 0
  to_port         = 0
  protocol        = "-1"
  source_security_group_id = "${aws_security_group.priv_security_group.id}"

  security_group_id = "${aws_security_group.master_security_group.id}"
}
resource "aws_security_group_rule" "master_pub_access" {
  depends_on      = ["aws_security_group.priv_security_group", "aws_security_group.pub_security_group", "aws_security_group.master_security_group"]
  type            = "ingress"
  from_port       = 0
  to_port         = 0
  protocol        = "-1"
  source_security_group_id = "${aws_security_group.pub_security_group.id}"

  security_group_id = "${aws_security_group.master_security_group.id}"
}

resource "aws_security_group_rule" "priv_master_access" {
  depends_on      = ["aws_security_group.priv_security_group", "aws_security_group.pub_security_group", "aws_security_group.master_security_group"]
  type            = "ingress"
  from_port       = 0
  to_port         = 0
  protocol        = "-1"
  source_security_group_id = "${aws_security_group.master_security_group.id}"

  security_group_id = "${aws_security_group.priv_security_group.id}"
}
resource "aws_security_group_rule" "priv_pub_access" {
  depends_on      = ["aws_security_group.priv_security_group", "aws_security_group.pub_security_group", "aws_security_group.master_security_group"]
  type            = "ingress"
  from_port       = 0
  to_port         = 0
  protocol        = "-1"
  source_security_group_id = "${aws_security_group.pub_security_group.id}"

  security_group_id = "${aws_security_group.priv_security_group.id}"
}

resource "aws_security_group_rule" "pub_master_access" {
  depends_on      = ["aws_security_group.priv_security_group", "aws_security_group.pub_security_group", "aws_security_group.master_security_group"]
  type            = "ingress"
  from_port       = 0
  to_port         = 0
  protocol        = "-1"
  source_security_group_id = "${aws_security_group.master_security_group.id}"

  security_group_id = "${aws_security_group.pub_security_group.id}"
}
resource "aws_security_group_rule" "pub_pri_access" {
  depends_on      = ["aws_security_group.priv_security_group", "aws_security_group.pub_security_group", "aws_security_group.master_security_group"]
  type            = "ingress"
  from_port       = 0
  to_port         = 0
  protocol        = "-1"
  source_security_group_id = "${aws_security_group.priv_security_group.id}"

  security_group_id = "${aws_security_group.pub_security_group.id}"
}

