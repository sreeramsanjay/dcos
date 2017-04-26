resource "aws_security_group" "mgmt_security_group" {
    name = "${var.project_tag}-mgmt-access"
    description = "management access to vpc & mckinsey network"
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

#allow traffic for TCP 22
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.ssh_source_cidr_block}"]
    }

#allows ssh traffic from the vpc
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.vpc_cidr}"]
    }

#allows http traffic from the vpc
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["${var.vpc_cidr}"]
    }

#allows https traffic from the vpc
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["${var.vpc_cidr}"]
    }

}

output "mgmt_security_group_id" {
  value = "${aws_security_group.mgmt_security_group.id}"
}

