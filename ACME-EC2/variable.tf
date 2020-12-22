## Variable

##### TAGS
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


##### Resource Tags
# DATA
variable "APPSubnet01Name" {
    default = ""
}

variable "APPVpcName" {
    default = ""
}

variable "ami_pattern" {
  default = {
    "awsami"  = "Amazon Linux AMI*"
    "linux"   = "RHEL-7.5_HVM_GA-*"
    "windows" = "Windows_Server-2016-English-Full-Base*"
    "ubuntu"  = "ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server*"
  }
}

variable "ami" {
  default = "linux"  # awsami , windows, ubuntu
}

variable "kmsname" {
    default = ""
}

# Resource

variable "ami_type" {
    default = ""
}

variable "amid" {
    default = ""
}



variable "instance_type" {
    default = "t3.small"
    description = "EC2 instance type to use"
}
variable "ami-id" {
    default = ""
}


variable "key_name" {
    default = "123"
}

# variable "security_group_ids" {
#     default = [""]
# }


# variable "subnet_id" {
#   default = ""
# }
  
variable "sdcheck" {
  default = "true"
}

variable "volume_type" {
    default = ""
}  

variable "volume_size" {
    default  = ""
}

variable "delete_on_termination" {
    default  = ""
}

variable "encrypted" {
    default  = ""
}

variable "ebs_optimized" {
    default = "true"
}


variable "SourceAddressEC2connect-1" {
    default = "10.0.0.0/16"
}

variable "SourceAddressEC2connect-2" {
    default = "10.0.2.0/16"
}

variable "sourceportconnect" {
    default = "22"
}


