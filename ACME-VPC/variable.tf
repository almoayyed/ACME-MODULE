######################
# TAGS

variable "Region" {
  default = "ME"
}

variable "env" {
  default = ""
}

variable "service" {
  default = ""
}

variable "Environment" {
  default = ""
}

variable "Owner" {
  default = "ALBA"
}





###########################################
#VPC  Variables
############################################

variable "availability_zones" {
  default     = [""]
  description = "The availability zones the we should create subnets in, launch instances in, and configure for ELB and ASG"
}

variable "az-tag" {
  default = [""]
}

variable "vpc_cidr" {
  default     = ""
  description = "The range of IP addresses that we use in this VPC"
}

variable "public_subnet_cidr" {
  default     = [""]
  description = "CIDR blocks for public subnets. Number of entries must match 'availability_zones'."
}

variable "private_subnet_cidr" {
  default     = [""]
  description = "CIDR blocks for private subnets. Number of entries must match 'availability_zones'."
}

variable "service_subnet_cidr" {
  default     = [""]
  description = "CIDR blocks for public subnets. Number of entries must match 'availability_zones'."
}

variable "tg_subnet_cidr" {
  default     = [""]
  description = "CIDR blocks for public subnets. Number of entries must match 'availability_zones'."
}

variable "db_subnet_cidr" {
  default     = [""]
  description = "CIDR blocks for public subnets. Number of entries must match 'availability_zones'."
}

# variable "domain_name" {
#   default = ""
# }

# variable "dns1" {
#   default = ""
# }

# variable "dns2" {
#   default = ""
# }

variable "vpcrange" {
  default = ""
}