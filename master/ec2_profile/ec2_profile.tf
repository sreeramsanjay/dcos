resource "aws_iam_role" "master_iam_role" {
   name = "dcos_master_iam_role"
   assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "master_instance_profile" {
  name = "dcos_master_instance_profile"
  roles = ["${aws_iam_role.master_iam_role.name}"]
}

resource "aws_iam_policy" "master_iam_policy" {
name = "dcos_master_iam_role_policy"
policy = "${file("../bootstap/s3_bucket/master_policy.json")}"
}

resource "aws_iam_policy_attachment" "master_policy" {
  name       = "dcos_master_policy_attachment"
  roles      = ["${aws_iam_role.master_iam_role.name}"]
  policy_arn = "${aws_iam_policy.master_iam_policy.arn}"
}

output "dcos_master_instance_profile" {
  value = "${aws_iam_instance_profile.master_instance_profile.name}"
}

