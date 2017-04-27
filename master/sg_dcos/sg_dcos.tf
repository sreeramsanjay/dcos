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

output "mgmt_security_group_id" {
  value = "${aws_security_group.master_security_group.id}"
}

