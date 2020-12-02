data "aws_region" "current" {}

# SECURITY HUB
# This will automatically generate a role in IAM with the default policy nothing to care about
resource "aws_securityhub_account" "shub" {}

# To enable the standard CIS checks
resource "aws_securityhub_standards_subscription" "shub" {
  depends_on    = ["aws_securityhub_account.shub"]
  standards_arn = "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0"
}

# GUARDDUTY
resource "aws_guardduty_detector" "member" {
  enable = true
}

# Accept the member account to join security account. NOTE- Deploy only if invitation is send from security account
resource "aws_guardduty_invite_accepter" "member" {
  detector_id       = "${aws_guardduty_detector.member.id}"
  master_account_id = "${var.Audit_Account_No}"
}

# IAM ANALYZER
resource "aws_accessanalyzer_analyzer" "example" {
  analyzer_name = "${var.Region}-${var.env_short}-${var.appname}-ANALYZER-IAM-${var.number}"
}

# CLOUDWATCH EVENT Trigger



###################################
#First Config EventRule
# CloudWatch Event Rule that detects changes to AWS Config and publishes change events to security account CW
####################################

resource "aws_cloudwatch_event_rule" "EventRule" {
  name = "detect-config-rule-compliance-changes"
  description = "A CloudWatch Event Rule that detects changes to AWS Config and publishes change events to security account CW."
  is_enabled = true
  event_pattern = <<PATTERN
{
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "config.amazonaws.com"
    ],
    "eventName": [
      "PutConfigurationRecorder",
      "StopConfigurationRecorder",
      "DeleteDeliveryChannel",
      "PutDeliveryChannel"
    ]
  }
}
PATTERN

}

resource "aws_cloudwatch_event_target" "TargetForEventRule" {
  rule = "${aws_cloudwatch_event_rule.EventRule.name}"
  target_id = "target-id1"
  arn = "arn:aws:events:${data.aws_region.current.name}:${var.Audit_Account_No}:event-bus/default"
  role_arn = "${aws_iam_role.test_role.arn}"
}


##########################################
#Second EventRule 
#CloudWatch Event Rule that triggers on changes in the status of AWS Personal Health Dashboard (AWS Health) and forwards the events to security account CW
###############################################

resource "aws_cloudwatch_event_rule" "EventRule2" {
  name = "detect-aws-health-events"
  description = "A CloudWatch Event Rule that triggers on changes in the status of AWS Personal Health Dashboard (AWS Health) and forwards the events to security account CW."
  is_enabled = true
  event_pattern = <<PATTERN
{
  "detail-type": [
    "AWS Health Event"
  ],
  "source": [
    "aws.health"
  ]
}
PATTERN

}

resource "aws_cloudwatch_event_target" "TargetForEventRule2" {
  rule = "${aws_cloudwatch_event_rule.EventRule2.name}"
  target_id = "target-id2"
  arn = "arn:aws:events:${data.aws_region.current.name}:${var.Audit_Account_No}:event-bus/default"
  role_arn = "${aws_iam_role.test_role.arn}"
}


###############################
# Third EventRule
## CloudWatch Event Rule that triggers on Amazon GuardDuty findings. The Event Rule can be used to trigger 
###############################

resource "aws_cloudwatch_event_rule" "EventRule3" {
  name = "detect-guardduty-finding"
  description = "A CloudWatch Event Rule that triggers on Amazon GuardDuty findings. The Event Rule can be used to trigger to security account CW."
  is_enabled = true
  event_pattern = <<PATTERN
{
  "detail-type": [
    "GuardDuty Finding"
  ],
  "source": [
    "aws.guardduty"
  ]
}
PATTERN

}

resource "aws_cloudwatch_event_target" "TargetForEventRule3" {
  rule = "${aws_cloudwatch_event_rule.EventRule3.name}"
  target_id = "target-id3"
  arn = "arn:aws:events:${data.aws_region.current.name}:${var.Audit_Account_No}:event-bus/default"
  role_arn = "${aws_iam_role.test_role.arn}"
}


###############################
# Fourth EventRule
## CloudWatch Event Rule that triggers on AWS Security Hub findings
###############################

resource "aws_cloudwatch_event_rule" "EventRule4" {
  name = "detect-securityhub-finding"
  description = "A CloudWatch Event Rule that triggers on AWS Security Hub findings. The Event Rule can be used to trigger security account CW."
  is_enabled = true
  event_pattern = <<PATTERN
{
  "detail-type": [
    "Security Hub Findings - Imported"
  ],
  "source": [
    "aws.securityhub"
  ]
}
PATTERN

}

resource "aws_cloudwatch_event_target" "TargetForEventRule4" {
  rule = "${aws_cloudwatch_event_rule.EventRule4.name}"
  target_id = "target-id4"
  role_arn = "${aws_iam_role.test_role.arn}"
  arn = "arn:aws:events:${data.aws_region.current.name}:${var.Audit_Account_No}:event-bus/default"
}

###############################
# FIFTH EventRule
## CloudWatch Event Rule that triggers on AWS Security Hub findings
###############################

resource "aws_cloudwatch_event_rule" "EventRule5" {
  name = "detect-cloudtrail-changes"
  description = "A CloudWatch Event Rule that detects changes to CloudTrail configutation and publishes change events to an security account CW ."
  is_enabled = true
  event_pattern = <<PATTERN
{
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "cloudtrail.amazonaws.com"
    ],
    "eventName": [
      "StopLogging",
      "DeleteTrail",
      "UpdateTrail"
    ]
  }
}
PATTERN

}

resource "aws_cloudwatch_event_target" "TargetForEventRule5" {
  rule = "${aws_cloudwatch_event_rule.EventRule5.name}"
  target_id = "target-id5"
  role_arn = "${aws_iam_role.test_role.arn}"
  arn = "arn:aws:events:${data.aws_region.current.name}:${var.Audit_Account_No}:event-bus/default"
}

###############################
# SIXTH EventRule
## CloudWatch Event Rule that detects IAM policy changes and publishes change events to
###############################

resource "aws_cloudwatch_event_rule" "EventRule6" {
  name = "detect-iam-policy-changes"
  description = "A CloudWatch Event Rule that detects IAM policy changes and publishes change events to an security account CW ."
  is_enabled = true
  event_pattern = <<PATTERN
{
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "iam.amazonaws.com"
    ],
    "eventName": [
      "DeleteRolePolicy",
      "DeleteUserPolicy",
      "PutGroupPolicy",
      "PutRolePolicy",
      "PutUserPolicy",
      "CreatePolicy",
      "DeletePolicy",
      "CreatePolicyVersion",
      "DeletePolicyVersion",
      "AttachRolePolicy",
      "DetachRolePolicy",
      "AttachUserPolicy",
      "DetachUserPolicy",
      "AttachGroupPolicy",
      "DetachGroupPolicy"
    ]
  }
}
PATTERN

}

resource "aws_cloudwatch_event_target" "TargetForEventRule6" {
  rule = "${aws_cloudwatch_event_rule.EventRule6.name}"
  target_id = "target-id6"
  role_arn = "${aws_iam_role.test_role.arn}"
  arn = "arn:aws:events:${data.aws_region.current.name}:${var.Audit_Account_No}:event-bus/default"
}

###############################
# Seventh EventRule
## CloudWatch Event Rule that triggers on IAM Access Analyzer Findings
###############################


resource "aws_cloudwatch_event_rule" "EventRule7" {
  name = "detect-accessanalyzer-finding"
  description = "A CloudWatch Event Rule that triggers on IAM Access Analyzer Findings. The Event Rule can be used to trigger notifications to an security account CW."
  is_enabled = true
  event_pattern = <<PATTERN
{
  "detail-type": [
    "Access Analyzer Finding"
  ],
  "source": [
    "aws.access-analyzer"
  ]
}
PATTERN

}

resource "aws_cloudwatch_event_target" "TargetForEventRule7" {
  rule = "${aws_cloudwatch_event_rule.EventRule7.name}"
    target_id = "target-id7"
  role_arn = "${aws_iam_role.test_role.arn}"
  arn = "arn:aws:events:${data.aws_region.current.name}:${var.Audit_Account_No}:event-bus/default"
}



###############################
# Eight EventRule
## CloudWatch Event Rule that triggers on IAM Access Analyzer Findings
###############################

resource "aws_cloudwatch_event_rule" "EventRule8" {
  name = "detect-security-group-changes"
  description = "A CloudWatch Event Rule that detects changes to security groups and publishes change events to an SNS topic for notification."
  is_enabled = true
  event_pattern = <<PATTERN
{
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "ec2.amazonaws.com"
    ],
    "eventName": [
      "AuthorizeSecurityGroupIngress",
      "AuthorizeSecurityGroupEgress",
      "RevokeSecurityGroupIngress",
      "RevokeSecurityGroupEgress",
      "CreateSecurityGroup",
      "DeleteSecurityGroup"
    ]
  }
}
PATTERN

}

resource "aws_cloudwatch_event_target" "TargetForEventRule8" {
  rule = "${aws_cloudwatch_event_rule.EventRule8.name}"
  target_id = "target-id8"
  role_arn = "${aws_iam_role.test_role.arn}"
  arn = "arn:aws:events:${data.aws_region.current.name}:${var.Audit_Account_No}:event-bus/default"
}


##### Iam Role for cloudwatch
resource "aws_iam_role" "test_role" {
  name = "${var.Region}-${var.env_short}-${var.appname}-IAMROLE-${var.number}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}

## Policy for cloudwatch event

resource "aws_iam_role_policy" "test_policy" {
  name = "${var.Region}-${var.env_short}-${var.appname}-IAMPOLICY-${var.number}"
  role = "${aws_iam_role.test_role.id}"

  policy = <<-EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "events:PutEvents"
            ],
            "Resource": [
                "arn:aws:events:${data.aws_region.current.name}:${var.Audit_Account_No}:event-bus/default"
            ]
        }
    ]
}
  EOF
}
