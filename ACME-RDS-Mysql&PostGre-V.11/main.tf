## RESOURCE
resource "aws_db_instance" "acme" {
  identifier              = "${var.database_identifier}"
  allocated_storage       = "${var.rds_allocated_storage}"
  engine                  = "${var.rds_engine_type}"
  engine_version          = "${var.rds_engine_version}"
  enabled_cloudwatch_logs_exports =["${var.cloudwatch_logs_exports}"] #["error","general","slowquery"]
  instance_class          = "${var.rds_instance_class}"
  name                    = "${var.database_name}"
  username                = "${var.database_user}"
  password                = "${var.database_master_password}" #var.database_password
  port                    = "${var.database_port}"
  storage_encrypted       =  "true"
  kms_key_id              = "${data.aws_kms_key.a.arn}"
  parameter_group_name    = "${var.parameter_group_name}" #"default.mysql8.0"
  vpc_security_group_ids  = ["${aws_security_group.dbsg.id}"]
  db_subnet_group_name    = "${aws_db_subnet_group.db.id}" #var.subnet_ids
  multi_az                = "${var.rds_is_multi_az}"
  storage_type            = "${var.rds_storage_type}"
  iops                    = "${var.rds_iops}"
  publicly_accessible     = "${var.publicly_accessible}"
  #Snapshots
  skip_final_snapshot     = "${var.skip_final_snapshot}" 
  copy_tags_to_snapshot   = "${var.copy_tags_to_snapshot}"
  #Backups
  backup_retention_period = "${var.backup_retention_period}"
  backup_window           = "${var.backup_window}"
  maintenance_window      = "${var.maintenance_window}"
  deletion_protection     = "${var.deletion_protection}"
  tags = {
         Name             = "${var.Region}-${var.env_short}-${var.appname}-RDSMYSQL-${var.number}"
         Environment      = "${var.environment}"
      }
}

output "rdsendpoint" {
  value = "${aws_db_instance.acme.endpoint}"
}



resource "aws_ssm_parameter" "acme" {
  name        = "/RDS/${var.Region}-${var.env_short}-${var.appname}-RDSMYSQL-${var.number}"
  description = "The parameter store for RDSMYSQL"
  type        = "SecureString"
  value       = "${var.database_master_password}"
  overwrite   = "true"

}


# DATA Parameter
data "aws_kms_key" "a" {
  key_id = "alias/${var.kmsname}"
}




data "aws_vpc" "db" {
  filter {
    name   = "tag:Name"
    values = ["${var.DBVpcName}"] # insert value here
  }
}

##### DB Subnet

data "aws_subnet" "db01" {
  filter {
    name   = "tag:Name"
    values = ["${var.DBSubnet01Name}"] # insert value here
  }
}

data "aws_subnet" "db02" {
  filter {
    name   = "tag:Name"
    values = ["${var.DBSubnet02Name}"] # insert value here
  }
}

resource "aws_db_subnet_group" "db" {
  name       = "${var.database_identifier}"  # db subnet group should be in lowercase
  subnet_ids = ["${data.aws_subnet.db01.id}", "${data.aws_subnet.db02.id}"]

  tags = {
    Name = "${var.Region}-${var.env_short}-${var.appname}-RDS-SUBNETGROUP-${var.number}"
  }
}


######### SECURITY GROUP
resource "aws_security_group" "dbsg" {
  name        = "${var.Region}-${var.env_short}-${var.appname}-RDSMYSQL-${var.number}"
  description = "Security group for RDSMYSQL - ${var.Region}-${var.env_short}-${var.appname}-RDSMYSQL-${var.number}"
  vpc_id      = "${data.aws_vpc.db.id}"

  tags = {
    Name               = "${var.Region}-${var.env_short}-${var.appname}-RDSMYSQL-${var.number}"
    Environment        = "${var.environment}"
  }
}


resource "aws_security_group_rule" "ruledb1" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.dbsg.id}"
  description       = "RDSMYSQL OutBound Rule"
}


resource "aws_security_group_rule" "ruledb2" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = ["${var.SourceAddressRdsSG}"] # Change it after ward
  security_group_id = "${aws_security_group.dbsg.id}"
  description       = "Mysql InBound Rule from source"
}