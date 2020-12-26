resource "aws_security_group" "sg" {
  #count = "${length(var.public_subnet_cidr)}"

  vpc_id = "${data.aws_vpc.APP.id}"

  tags = {
    Name               = "${var.Region}-${var.env_short}-${var.appname}-SG-${var.number}"
    Environment        = "${var.environment}"
  }
}


data "aws_vpc" "APP" {
  filter {
    name   = "tag:Name"
    values = ["${var.APPVpcName}"] # insert value here
  }
}