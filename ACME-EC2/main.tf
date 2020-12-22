
## DATA
data "aws_caller_identity" "current" {}

data "aws_ami" "base_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["${lookup(var.ami_pattern, var.ami)}"]
  }

  owners = ["137112412989", "309956199498", "801119661308", "099720109477"] #AWS Official Account no["${data.aws_caller_identity.current.account_id}"]
}

data "aws_vpc" "APP" {
  filter {
    name   = "tag:Name"
    values = ["${var.APPVpcName}"] # insert value here
  }
}

data "aws_subnet" "AP01" {
  filter {
    name   = "tag:Name"
    values = ["${var.APPSubnet01Name}"] # insert value here
  }
}

data "aws_kms_key" "a" {
  key_id = "alias/${var.kmsname}"
}

resource "aws_instance" "ec2_instance" {
  ami           = "${var.ami_type == "custom" ? var.amid : data.aws_ami.base_ami.id}" #
  subnet_id     =  "${data.aws_subnet.AP01.id}" #"${var.subnet_id}"
  instance_type = "${var.instance_type}"
  #iam_instance_profile = "${var.iam_instance_profile}"
  vpc_security_group_ids = ["${aws_security_group.sg.id}"]
  key_name               = "${var.key_name}"
  ebs_optimized          = "${var.ebs_optimized}"
  source_dest_check      = "${var.sdcheck}"
  #user_data              = "${var.user_data}"
  root_block_device  {
    volume_type           = "${var.volume_type}"
    volume_size           = "${var.volume_size}"
    delete_on_termination = "${var.delete_on_termination}"
    encrypted             = "${var.encrypted}"
    kms_key_id            = "${data.aws_kms_key.a.arn}"
  }

  tags = {
    Name               = "${var.Region}-${var.env_short}-${var.appname}-EC2-${var.number}"
    Environment        = "${var.environment}"
}

  lifecycle {
    ignore_changes = ["ami", "user_data", "subnet_id", "key_name", "ebs_optimized", "private_ip"]
  }
}


resource "aws_security_group" "sg" {
  name        = "${var.Region}-${var.env_short}-${var.appname}-SG-${var.number}"
  description = "Allow TLS inbound traffic"
  vpc_id      = "${data.aws_vpc.APP.id}"

  tags = {
    Name               = "${var.Region}-${var.env_short}-${var.appname}-SG-${var.number}"
    Environment        = "${var.environment}"
  }
}


resource "aws_security_group_rule" "rule1" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.sg.id}"
  description       = "OutBound Rule"
}


resource "aws_security_group_rule" "rule2" {
  type              = "ingress"
  from_port         = "${var.sourceportconnect}"
  to_port           = "${var.sourceportconnect}"
  protocol          = "tcp"
  cidr_blocks       = ["${var.SourceAddressEC2connect-1}", "${var.SourceAddressEC2connect-2}"] # Change it after ward
  security_group_id = "${aws_security_group.sg.id}"
  description       = "Bastion Host EC2"
}


