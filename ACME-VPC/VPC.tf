###################
# RESOURCE
###################


## VPC Flow Logs deployed of each account VPC

resource "aws_flow_log" "vpcflow" {
  iam_role_arn    = "${aws_iam_role.vpcflow.arn}"
  log_destination = "${aws_cloudwatch_log_group.vpcflow.arn}"
  traffic_type    = "ALL"
  vpc_id          = "${aws_vpc.main_vpc.id}"
}

resource "aws_cloudwatch_log_group" "vpcflow" {
  #name = "${var.Region}-${var.env}-VPC-${var.service}-${var.vpcrange}-vpcflowlog"
  retention_in_days = "180"
  name_prefix       = "${var.Region}-${var.env}-VPC-${var.service}-${var.vpcrange}-CW"

  tags = {
    Name        = "${var.Region}-${var.env}-CW-${var.service}"
    Environment = "${var.Environment}"
    Owner       = "${var.Owner}"
    
    Description = "${var.Environment} Environment VPC ${var.vpcrange}"
  }
}

resource "aws_iam_role" "vpcflow" {
  name = "${var.Region}-${var.env}-CW-IAM-${var.service}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = {
    Name        = "${var.Region}-${var.env}-IAM-${var.service}"
    Environment = "${var.Environment}"
    Owner       = "${var.Owner}"
    
    Description = "${var.Environment} Environment VPC ${var.vpcrange}"
  }
}

resource "aws_iam_role_policy" "vpcflow" {
  name = "${var.Region}-${var.env}-IAM-POLICY-${var.service}"
  role = "${aws_iam_role.vpcflow.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

####################################### VPC ##########################################################3
resource "aws_vpc" "main_vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"

  tags = {
    Name        = "${var.Region}-${var.env}-VPC-${var.service}-${var.vpcrange}"
    Environment = "${var.Environment}"
    Owner       = "${var.Owner}"
    
    Description = "${var.Environment} Environment VPC ${var.vpcrange}"
  }
}

###################
# Public subnets  #
###################

resource "aws_subnet" "public" {
  vpc_id            = "${aws_vpc.main_vpc.id}"
  cidr_block        = "${element(var.public_subnet_cidr, count.index)}"
  availability_zone = "${element(var.availability_zones, count.index)}"
  count             = "${length(var.public_subnet_cidr)}"

  tags = {
    Name        = "${var.Region}-${var.env}-SN-LB${element(var.az-tag, count.index)}"
    Environment = "${var.Environment}"
    Owner       = "${var.Owner}"
    
    Description = "${var.Environment} Environment Public Subnet"
  }

  #map_public_ip_on_launch = true
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main_vpc.id}"

  #count  = "${length(var.public_subnet_cidr)}"

  tags = {
    Name        = "${var.Region}-${var.env}-RT-LB${element(var.az-tag, count.index)}"
    Environment = "${var.Environment}"
    Owner       = "${var.Owner}"
    
    Description = "${var.Environment} Environment Public Subnet RouteTable"
  }
}

resource "aws_route_table_association" "public" {
  count          = "${length(var.public_subnet_cidr)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

###################
# APP subnets #
###################

resource "aws_subnet" "private" {
  vpc_id            = "${aws_vpc.main_vpc.id}"
  cidr_block        = "${element(var.private_subnet_cidr, count.index)}"
  availability_zone = "${element(var.availability_zones, count.index)}"
  count             = "${length(var.private_subnet_cidr)}"

  tags = {
    Name        = "${var.Region}-${var.env}-SN-AP${element(var.az-tag, count.index)}"
    Environment = "${var.Environment}"
    Owner       = "${var.Owner}"
    
    Description = "${var.Environment} Environment Application Subnet"
  }
}

/*
resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.main_vpc.id}"
  #count  = "${length(var.private_subnet_cidr)}"

  tags = {
    Name               = "${var.Region}-${var.env}-RT-AP${element(var.az-tag, count.index)}"
    Environment        = "${var.Environment}"
    Owner              = "${var.Owner}"
    
    Description        = "${var.Environment} Environment Application Subnet RouteTable"
  }
}
/*
resource "aws_route_table_association" "private" {
  count          = "${length(var.private_subnet_cidr)}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  #route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
}
*/

##################################
# SERVICE-SUBNET
##################################

resource "aws_subnet" "service" {
  vpc_id            = "${aws_vpc.main_vpc.id}"
  cidr_block        = "${element(var.service_subnet_cidr, count.index)}"
  availability_zone = "${element(var.availability_zones, count.index)}"
  count             = "${length(var.service_subnet_cidr)}"

  tags = {
    Name        = "${var.Region}-${var.env}-SN-SR${element(var.az-tag, count.index)}"
    Environment = "${var.Environment}"
    Owner       = "${var.Owner}"
    
    Description = "${var.Environment} Environment Service Subnet"
  }
}

/*
resource "aws_route_table" "service" {
  vpc_id = "${aws_vpc.main_vpc.id}"
  #count  = "${length(var.private_subnet_cidr)}"

  tags = {
    Name               = "${var.Region}-${var.env}-RT-SR${element(var.az-tag, count.index)}"
    Environment        = "${var.Environment}"
    Owner              = "${var.Owner}"

    Description        = "${var.Environment} Environment Service Subnet RouteTable"
}
}

resource "aws_route_table_association" "service" {
  count          = "${length(var.service_subnet_cidr)}"
  subnet_id      = "${element(aws_subnet.service.*.id, count.index)}"
  #route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.service.id}"
}
*/

###################
# DB subnets #
###################

resource "aws_subnet" "db" {
  vpc_id            = "${aws_vpc.main_vpc.id}"
  cidr_block        = "${element(var.db_subnet_cidr, count.index)}"
  availability_zone = "${element(var.availability_zones, count.index)}"
  count             = "${length(var.db_subnet_cidr)}"

  tags = {
    Name        = "${var.Region}-${var.env}-SN-DB${element(var.az-tag, count.index)}"
    Environment = "${var.Environment}"
    Owner       = "${var.Owner}"
    
    Description = "${var.Environment} Environment Database Subnet"
  }
}

/*
resource "aws_route_table" "db" {
  vpc_id = "${aws_vpc.main_vpc.id}"
  #count  = "${length(var.private_subnet_cidr)}"

  tags = {
    Name               = "${var.Region}-${var.env}-RT-DB${element(var.az-tag, count.index)}"
    Environment        = "${var.Environment}"
    Owner              = "${var.Owner}"

    Description        = "${var.Environment} Environment Database Subnet RouteTable"
  }
}

resource "aws_route_table_association" "db" {
  count          = "${length(var.db_subnet_cidr)}"
  subnet_id      = "${element(aws_subnet.db.*.id, count.index)}"
  #route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.db.id}"
}
*/
#############################
# TRANSIT GATEWAY SUBNET
#############################

resource "aws_subnet" "tg" {
  vpc_id            = "${aws_vpc.main_vpc.id}"
  cidr_block        = "${element(var.tg_subnet_cidr, count.index)}"
  availability_zone = "${element(var.availability_zones, count.index)}"
  count             = "${length(var.tg_subnet_cidr)}"

  tags = {
    Name        = "${var.Region}-${var.env}-SN-TG${element(var.az-tag, count.index)}"
    Environment = "${var.Environment}"
    Owner       = "${var.Owner}"
    
    Description = "${var.Environment} Environment Transit Gateway Subnet"
  }
}

resource "aws_route_table" "tg" {
  vpc_id = "${aws_vpc.main_vpc.id}"

  #count  = "${length(var.private_subnet_cidr)}"

  tags = {
    Name        = "${var.Region}-${var.env}-RT-TG${element(var.az-tag, count.index)}"
    Environment = "${var.Environment}"
    Owner       = "${var.Owner}"
    
    Description = "${var.Environment} Environment Transit Gateway RouteTable"
  }
}

resource "aws_route_table_association" "tg" {
  count     = "${length(var.tg_subnet_cidr)}"
  subnet_id = "${element(aws_subnet.tg.*.id, count.index)}"

  #route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.tg.id}"
}

resource "aws_route_table_association" "db" {
  count     = "${length(var.db_subnet_cidr)}"
  subnet_id = "${element(aws_subnet.db.*.id, count.index)}"

  #route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.tg.id}"
}

resource "aws_route_table_association" "service" {
  count     = "${length(var.service_subnet_cidr)}"
  subnet_id = "${element(aws_subnet.service.*.id, count.index)}"

  #route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.tg.id}"
}

resource "aws_route_table_association" "private" {
  count     = "${length(var.private_subnet_cidr)}"
  subnet_id = "${element(aws_subnet.private.*.id, count.index)}"

  #route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.tg.id}"
}