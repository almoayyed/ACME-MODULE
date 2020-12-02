data "aws_caller_identity" "current" {}

resource "aws_kms_key" "KmsKey" {
enable_key_rotation  = "true"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "Default Key Policy",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      },
      "Action": "kms:*",
      "Resource": "*"
    }
  ]
}
POLICY
}




resource "aws_kms_alias" "a" {
  name          = "alias/${var.Region}-${var.env_short}-${var.appname}-CMK-${var.number}"
  target_key_id = "${aws_kms_key.KmsKey.key_id}"
}

# DEFAULT Encryption on Account level
resource "aws_ebs_encryption_by_default" "KmsKey" {
  enabled    = true
}

resource "aws_ebs_default_kms_key" "ebs" {
  key_arn = "${aws_kms_key.KmsKey.arn}"
}
