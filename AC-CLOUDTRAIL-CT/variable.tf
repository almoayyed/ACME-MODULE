## Comman ACME tags
######################
# TAGS

variable "Region" {
  default = "ME"
}

variable "env_short" {
  default = "P"
}

variable "appname" {
  default = "NS"
}

variable "service" {
  default = "CT"
}


## Resource name

variable "snstopicname" {
    default = "ME-P-NS-SNS"
}

variable "cloudwatch_loggroup_name" {
    default = ""
}

variable "logaccountdestination_bucket" {
  default = ""
}