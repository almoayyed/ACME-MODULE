resource "aws_s3_account_public_access_block" "BlockPublicAccess" {
  block_public_acls = "${var.block_public_acls}"
  ignore_public_acls = "${var.ignore_public_acls}"
  block_public_policy = "${var.block_public_policy}"
  restrict_public_buckets = "${var.restrict_public_buckets}"
}
