variable "database_identifier" {
  default     = "bc-prod01-postgresql-01"
  description = "Identifier name for RDS instance"
}

variable "rds_allocated_storage" {
  description = "The allocated storage in GBs"
  default     = "200"

}

variable "cloudwatch_logs_exports" {
  default = ""
}
variable "rds_engine_type" {
  description = "Database engine type"
  default     = "postgres" #"mysql"
}

variable "rds_engine_version" {
  description = "Database engine version, depends on engine type"
  default     = "12.3"
}

variable "cloudwatch_logs_exports" {
  description = "RDS Cloudwatch log exports"
  default = ""
}


variable "rds_instance_class" {
  description = "Class of RDS instance"
  default     = "db.m5.large"
}

variable "database_name" {
  default = "defaultname_web_rds_mysql"
}

variable "database_user" {
  default = "bc_prod01_admin"
}

variable "rds_is_multi_az" {
  description = "Set to true on production"
  default     = "true"
}

variable "rds_storage_type" {
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD)."
  default     = "gp2"
}

variable "rds_iops" {
  description = "The amount of provisioned IOPS. Setting this implies a storage_type of 'io1', default is 0 if rds storage type is not io1"
  default     = "0"
}

variable "publicly_accessible" {
  description = "Determines if database can be publicly available (NOT recommended)"
  default     = false
}

variable "skip_final_snapshot" {
  default = "true" # CHANGE TO FALSE
}

variable "copy_tags_to_snapshot" {
  default = "true"
}

variable  "backup_retention_period" {
  description = "Number of days to keep database backups"
  default     = 30
}

variable "backup_window" {
  description = "When AWS can run snapshot, can't overlap with maintenance window"
  default     = "10:39-11:09"
}


variable "maintenance_window" {
  description = "The window to perform maintenance"
  default     = "sun:03:00-sun:03:30"
}


variable "database_master_password" {
    description = "Password for database master"
    default  = ""
}

variable "database_port" {
  default     = 5432
  description = "Port on which database will accept connections"
}

variable "parameter_group_name" {
  default = "default.postgres12" #"default.mysql8.0"
}

variable "deletion_protection" {
  default     = true
  description = "Flag to protect the database instance from deletion"
}

variable "kmsname" {
    description = "KMS Keyname for encryption of RDSMYSQL"
    default = ""
}

variable "DBVpcName" {
    description = "DB VPC Name"
    default = ""
}

variable "DBSubnet01Name" {
    description = "DB Subnet 01"
    default     = ""
}

variable "DBSubnet02Name" {
    description = "DB Subnet 01"
    default     = ""
}

variable "SourceAddressRdsSG" {
    description = "Enter source instance ip address to access RDSMYSQL"
    default = ""
}

## Comman ACME tags
######################
# TAGS

variable "Region" {
  default = "ME"
}

variable "env_short" {
  default = "D"
}

variable "appname" {
  default = "CT"
}

variable "number" {
  default = "01"
}

variable "environment" {
  default = "DEV"
}