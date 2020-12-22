# ACME CLOUD -Generic Module
How to use a ACME TERRAFORM function to DEPLOY the AWS Resource.

# Short Description
When a new instance is created, whether it is created on the web console, using the CLI or one of the AWS SDKs or through terraform, they will be created with at least one EBS volume (except for instance store instances) and one network interface, however the API call CreateTags will not propagate the tags to these dependent resources. To resolve this problem, we are going to use CloudWatch Events and Lambda to detect when instance tags are modified and then automatically tag the EBS volumes and ENIs that are attached to the instance.
We are going to take advantage a feature of CloudWatch Events that can trigger events every time an EC2 API call is invoked and specifically we will trigger it when CreateTags is invoked by an IAM user or a role and then forward the event to Lambda, Lambda will then check if the tagged resources were instances and if they are, since the event will contain the instance ids, we can use the event information to tag the EBS volumes and the ENIs attached to the instance.

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

## ACME Generic EC2
```
module "ACME-EC2" {
    source = "github.com/almoayyed/ACME-MODULE/ACME-EC2" 
    
    # Compute
    ami_type         = "custom" # custom or nocustom ami
    amid             = "ami-0ce1e3f77cd41957e" # If Custom AMI entry the ami ID else leave it blank
    instance_type    = "t3.small"
    key_name         = "ACME-JIRA"
    
    # Storage
    volume_type      = "gp2"
    volume_size      = "30"
    delete_on_termination = "true"
    encrypted        = "true"
    kmsname           = "IR-P-KMS-K-04"
    
    # Network
    sourceportconnect = "22" # 22 OR 3389
    SourceAddressEC2connect-1 = "10.0.0.0/16" #(Source Address to connect EC2)
    SourceAddressEC2connect-2 = "172.0.0.0/16"
    APPVpcName        = "Main_VPC"
    APPSubnet01Name   = "ACME_SUBNET_W01_T_MM"
    
```


