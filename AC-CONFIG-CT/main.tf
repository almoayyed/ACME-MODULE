data "aws_caller_identity" "current" {}

resource "aws_config_configuration_recorder" "ConfigurationRecorder" {
  role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-controltower-ConfigRecorderRole"

  recording_group {
    all_supported = true
    include_global_resource_types = true
  }
}

resource "aws_config_delivery_channel" "DeliveryChannel" {
  s3_bucket_name = "${var.logaccountdestination_bucket}" # Log Account Bucket name
  #s3_key_prefix  = "${var.s3_key_prefix}"
  depends_on = [ "aws_config_configuration_recorder.ConfigurationRecorder" ]
}



resource "aws_config_configuration_recorder_status" "ConfigurationRecorderStatus" {
  name = "${aws_config_configuration_recorder.ConfigurationRecorder.name}"
  is_enabled = true
  depends_on = [ "aws_config_delivery_channel.DeliveryChannel" ]
}