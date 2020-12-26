##################
# #LOAD BALANCER
# ##################

resource "aws_lb" "loadbalancer" {
  internal        = "${var.internal}"
  name            = "${var.Region}-${var.env_short}-${var.appname}-ALB-${var.number}"
  subnets         = ["${data.aws_subnet.AP01.id}", "${data.aws_subnet.AP02.id}"]
  security_groups = ["${aws_security_group.sg.id}"]

  tags = {
    Name               = "${var.Region}-${var.env_short}-${var.appname}-ALB-${var.number}"
    Environment        = "${var.environment}"
  }
}

resource "aws_lb_target_group" "lb_target_group" {
  name                          =  "${var.Region}-${var.env_short}-${var.appname}-ALB-TG-${var.number}"
  port                          = "${var.tgport}"
  protocol                      = "${var.tgprotocol}"
  vpc_id                        = "${data.aws_vpc.ac.id}"
  target_type                   = "instance"
  load_balancing_algorithm_type = "round_robin"

  health_check {
    healthy_threshold   = "3"
    interval            = "10"
    timeout             = "5"
    port                = "traffic-port"
    path                = "${var.heathcheck_path}"
    protocol            = "${var.tgprotocol}"
    unhealthy_threshold = "3"
    matcher             = "200-301"
  }

  tags = {
    Name               = "${var.Region}-${var.env_short}-${var.appname}-ALB-TG-${var.number}"
    Environment        = "${var.environment}"
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = "${aws_lb.loadbalancer.arn}"
  port              = "${var.lisport}"
  protocol          = "${var.lisprotocol}"

  default_action {
    type = "forward"
    target_group_arn = "${aws_lb_target_group.lb_target_group.arn}"
  }
}


resource "aws_security_group" "sg" {
  name        = "${var.Region}-${var.env_short}-${var.appname}-SG-${var.number}"
  description = "Allow HTTP inbound traffic"
  vpc_id      = "${data.aws_vpc.ac.id}"

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
  from_port         = "${var.lisport}"
  to_port           = "${var.lisport}"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] #["${var.SourceAddressEC2connect-1}", "${var.SourceAddressEC2connect-2}"] # Change it after ward
  security_group_id = "${aws_security_group.sg.id}"
  description       = "ALB INBOUND"
}


## DATA
data "aws_vpc" "ac" {
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

data "aws_subnet" "AP02" {
  filter {
    name   = "tag:Name"
    values = ["${var.APPSubnet02Name}"] # insert value here
  }
}


