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

variable "ami_pattern" { # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/finding-an-ami.html
  default = {
    "awsami"  = "amzn2-ami-hvm-2.0*" # 137112412989
    "redhat7"   = "RHEL-7.9_HVM_GA-*" # Red Hat Enterprise Linux 7.0_HVM_GA # 309956199498
    "redhat6"   = "RHEL-6.7_HVM_GA-*" 
    "redhat8"   = "RHEL-8.2_HVM-*" 
    # aws ec2 describe-images --owners 309956199498 --query 'sort_by(Images, &CreationDate)[*].[CreationDate,Name,ImageId]' --filters "Name=name,Values=RHEL-6*" --region eu-west-1 --output table
    "windows2016" = "Windows_Server-2016-English-Full-Base*" #801119661308 
    "windows2019" = "Windows_Server-2019-English-Full-Base*"
    "ubuntu16"  = "ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server*" # 099720109477
    "ubuntu18"  = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server*"
    "ubuntu20"  = "ubuntu/images/hvm-ssd/ubuntu-groovy-20.10-amd64-server*"
    # Ubuntu Image locator https://cloud-images.ubuntu.com/locator/ec2/
  }
}

variable "ami" {
  default = "awsami"  # awsami , windows, ubuntu
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


