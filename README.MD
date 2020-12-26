# ACME CLOUD -Generic Module
How to use a ACME TERRAFORM Module to DEPLOY the AWS Resource.

# Short Description
ACME-Modules:
Contains modules which are to be used for creating any AWS services instead of directly calling terraform resource function. Their can be specific cases (e.g: When adding Security Group Rules) when we can directly call terraform resource function, but for most of services its preferred to use modules when creating/using new AWS services under any accounts. If module is not present for any AWS service, contact AWS Landing Zone team to create a module which can be call'd from Workspace / Application terraform template.

Modules present for : VPC, EC2, S3, RDS, IAM, ELB, ASG, Lambda, Cloudfront, API Gateway

# Resolution
In order to use this module clone the repository on your local system 

# Pre-Requisites
* Runtime: HCL, Terraform version 11.4
* Role with permissions to log to access the AWS Environment


## ACME Generic RDS - ACME-RDS-Mysql&PostGre-V.11
```
module "ACME-RDS" {
    source = "github.com/almoayyed/ACME-MODULE/ACME-RDS-Mysql&PostGre-V.11" 
    
    kmsname = "abcd" #(KMS name to encrypt the RDS)
    DBVpcName = "Main_VPC"  #(VPC Name of RDS)
    DBSubnet01Name = "ACME_SUBNET_W01_T_MM" #(RDS Subnet group)
    DBSubnet02Name = "ACME_SUBNET_W02_T_MM" #(RDS Subnet group)
    SourceAddressRdsSG = "10.56.0.0/16"     #(Source Address for accessing RDS)
    database_identifier = "bc-prod01-postgresql-01" # KEEP it small letter
    database_master_password = ""
    rds_engine_type  = "postgres" # "mysql"
    rds_engine_version = "12.3" 
    cloudwatch_logs_exports = "postgresql" # FOR POSTRGRE - [postgresql], FOR MYSQL- ["error","general","slowquery"]
    rds_instance_class = "db.m5.large"
    database_name      = ""
    database_user      = ""
    rds_is_multi_az    = "false" #(True in PROD)
    publicly_accessible = "false"
    database_port      = "5432" #3306
    parameter_group_name = "default.postgres12" # "default.mysql8.0"
}
```

## ACME Generic RDS - ACME-RDS-Mysql&PostGre-V.12
```
module "ACME-RDS" {
    source = "github.com/almoayyed/ACME-MODULE/ACME-RDS-Mysql&PostGre-V.12"
    
    kmsname = "abcd" #(KMS name to encrypt the RDS)
    DBVpcName = "Main_VPC"  #(VPC Name of RDS)
    DBSubnet01Name = "ACME_SUBNET_W01_T_MM" #(RDS Subnet group)
    DBSubnet02Name = "ACME_SUBNET_W02_T_MM" #(RDS Subnet group)
    SourceAddressRdsSG = "10.56.0.0/16"     #(Source Address for accessing RDS)
    database_identifier = "bc-prod01-postgresql-01" # KEEP it small letter
    database_master_password = ""
    rds_engine_type  = "postgres" # "mysql"
    rds_engine_version = "12.3" 
    cloudwatch_logs_exports = "postgresql" # FOR POSTRGRE - [postgresql], FOR MYSQL- ["error","general","slowquery"]
    rds_instance_class = "db.m5.large"
    database_name      = ""
    database_user      = ""
    rds_is_multi_az    = "false" #(True in PROD)
    publicly_accessible = "false"
    database_port      = "5432" #3306
    parameter_group_name = "default.postgres12" # "default.mysql8.0"
}
```

## ACME Generic EC2 Instance
```
module "ACME-EC2" {
    source = "github.com/almoayyed/ACME-MODULE/ACME-EC2" 
    
    # Compute
    ami_type         = "nocustom" # custom or nocustom ami
    amid             = "" # For *custom AMI enter the ami ID or else leave it blank
    instance_type    = "t3.small"
    key_name         = "ACME-JIRA"
    ami              = ""  # REDHAT [redhat7, redhat6, redhat8], UBUNTU [ubuntu16, ubuntu18, ubuntu20], WINDOWS [windows2016, windows2019], AMAZON AMI [awsami]
    
    # Storage
    volume_type      = "gp2"
    volume_size      = "30"
    delete_on_termination = "true"
    encrypted        = "true"
    kmsname           = "IR-P-KMS-K-04"
    
    # Network
    sourceportconnect = "22" # 22 OR 3389
    SourceAddressEC2connect-1 = "10.0.0.0/16" #(Source1 Address to connect EC2)
    SourceAddressEC2connect-2 = "172.0.0.0/16" #(Source2 Address to connect EC2)
    APPVpcName        = "Main_VPC" 
    APPSubnet01Name   = "ACME_SUBNET_W01_T_MM"
    
    # Tags
    Region            = "ME"
    env_short         = "P"
    appname           = "CT"
    number            = "01"
    environment       = "PROD"
}

```


## ACME Generic Security Group
```
module "ACME-SG" {
    source = "github.com/almoayyed/ACME-MODULE/ACME-SG"
    
    APPVpcName = "Main_VPC"
}

resource "aws_security_group_rule" "allow_https" {
  type            = "ingress"
  from_port       = 443
  to_port         = 443
  protocol        = "tcp"
  cidr_blocks     =["0.0.0.0/0"]
  security_group_id = "${module.ACME-SG.sg_id}"
}


resource "aws_security_group_rule" "allow_mysql" {
  type            = "ingress"
  from_port       = 3306
  to_port         = 3306
  protocol        = "tcp"
  cidr_blocks     =["0.0.0.0/0"]
  security_group_id = "${module.ACME-SG.sg_id}"
}

resource "aws_security_group_rule" "allow_outbound" {
  type            = "egress"
  from_port       = 0
  to_port         = 0
  protocol        = "-1"
  cidr_blocks     =["0.0.0.0/0"]
  security_group_id = "${module.ACME-SG.sg_id}"
}

```

## ACME Generic S3 bucket
```
module "ACME-S3" {
    source = "github.com/almoayyed/ACME-MODULE/ACME-S3"
    
    bucket_name = ""
    
}
```

## ACME Generic ALB

```
module "ACME-ALB" {
    source = "github.com/almoayyed/ACME-MODULE/ACME-ALB"
    
    APPVpcName = "Main_VPC"
    APPSubnet01Name = "ACME_SUBNET_W01_T_MM"
    APPSubnet02Name = "ACME_SUBNET_W02_T_MM"
    
    # ALB
    internal     = "true"
    tgport       = "80"
    tgprotocol   = "HTTP"
    heathcheck_path = "/index.html"
    lisport      = "80"
    lisprotocol  = "HTTP"
    
    # Tags
    Region            = "ME"
    env_short         = "P"
    appname           = "CT"
    number            = "01"
    environment       = "PROD"
}
```
