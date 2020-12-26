resource "aws_s3_bucket" "acme" {
  bucket = "${var.bucket_name}"  # "detailedcomputeinventory-${random_id.s3id.hex}" #resource "random_id" "s3id" { byte_length = 8 }
  acl    = "private"
#Default encryption	AES-256 - bucket
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
}
}

## Block Public Access
resource "aws_s3_bucket_public_access_block" "blockpublic" {
  bucket = "${aws_s3_bucket.acme.id}"

  block_public_acls   = true
  block_public_policy = true
}
