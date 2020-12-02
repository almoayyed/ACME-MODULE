#data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

########################
# CLOUDTRAIL
########################


resource "aws_cloudtrail" "foobar" {
  name                          = "${var.Region}-${var.env_short}-${var.appname}-CLOUDTRAIL"
  s3_bucket_name                = "${var.logaccountdestination_bucket}"
  #s3_key_prefix                 = "CloutrailLogs"
  include_global_service_events = true
  sns_topic_name                = "${aws_sns_topic.sns.arn}"
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.cw.arn}"
  cloud_watch_logs_role_arn     = "${aws_iam_role.cloudtrail_cloudwatch_events_role.arn}"
  is_multi_region_trail         = "true" # Specifies whether the trail is created in the current region or in all regions. CIS 2.1 
  enable_log_file_validation    = "true" # Specifies whether log file integrity validation is enabled.CIS 2.2 
}



resource "aws_sns_topic" "sns" {
  name = "${var.snstopicname}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailSNSPolicy20131101",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "SNS:Publish",
            "Resource": "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${var.snstopicname}"
        }
    ]
}
EOF
}

# resource "aws_s3_bucket" "foo" {
#   bucket        = "${var.s3_bucket_name}"
#   force_destroy = true
#   acl = "log-delivery-write"
#   server_side_encryption_configuration {
#     rule {
#       apply_server_side_encryption_by_default {
#         kms_master_key_id =  "${aws_kms_key.KmsKey.key_id}"
#         sse_algorithm     = "aws:kms"
#       }
#     }
#   }
#   logging {
#     target_bucket = "${var.s3_bucket_name}"
#     target_prefix = "Accesslogs/"
#   }
#   policy = <<POLICY
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Sid": "AWSCloudTrailAclCheck",
#             "Effect": "Allow",
#             "Principal": {
#               "Service": "cloudtrail.amazonaws.com"
#             },
#             "Action": "s3:GetBucketAcl",
#             "Resource": "arn:aws:s3:::${var.s3_bucket_name}"
#         },
#         {
#             "Sid": "AWSCloudTrailWrite",
#             "Effect": "Allow",
#             "Principal": {
#               "Service": "cloudtrail.amazonaws.com"
#             },
#             "Action": "s3:PutObject",
#             "Resource": "arn:aws:s3:::${var.s3_bucket_name}/CloutrailLogs/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
#             "Condition": {
#                 "StringEquals": {
#                     "s3:x-amz-acl": "bucket-owner-full-control"
#                 }
#             }
#         }
#     ]
# }
# POLICY
# }


################################
# CLOUDWATCH STREAM IAM ROLE
################################

resource "aws_cloudwatch_log_group" "cw" {
  name = "${var.Region}-${var.env_short}-${var.appname}-CLOUDWATCH-LOGGROUP"
}



resource "aws_iam_role" "cloudtrail_cloudwatch_events_role" {
  name_prefix        = "AWS-CloudTrail-IAM"
  assume_role_policy = "${data.aws_iam_policy_document.assume_policy.json}"
}

resource "aws_iam_role_policy" "policy" {
  name_prefix = "AWS_cloudtrail_cloudwatch_events_policy"
  role        = "${aws_iam_role.cloudtrail_cloudwatch_events_role.id}"
  policy      = "${data.aws_iam_policy_document.policy.json}"
}
## assume
data "aws_iam_policy_document" "assume_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals = {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

## policy
data "aws_iam_policy_document" "policy" {
  statement {
    effect  = "Allow"
    actions = ["logs:CreateLogStream"]

    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${aws_cloudwatch_log_group.cw.name}:log-stream:*",
    ]
  }

  statement {
    effect  = "Allow"
    actions = ["logs:PutLogEvents"]

    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${aws_cloudwatch_log_group.cw.name}:log-stream:*",
    ]
  }
}