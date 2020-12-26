# ACME CLOUD -Generic Module
How to use a ACME TERRAFORM Module to DEPLOY the AWS Resource.

# Short Description
ACME TF Module is a generic module for all AWS infra service. It is build with all the best practises.
User can import the module and change the certain value to lauch the respective services

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
    
```


