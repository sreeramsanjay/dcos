resource "aws_s3_bucket" "bucket" {
  bucket = "${var.bucket_name}"
  acl    = "private"

  tags {
    Name        = "dcos-bootstrap"
    Environment = "${var.project_tag}"
  }
}

resource "aws_s3_bucket_policy" "policy" {
  bucket = "${aws_s3_bucket.bucket.id}"
  policy = "${file("../bootstap/s3_bucket/policy.json")}"
}

#output "bs_bucket_name" {
#  value = "${aws_s3_bucket.bucket.name}"
#}
