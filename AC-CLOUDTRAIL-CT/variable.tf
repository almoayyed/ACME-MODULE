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
  default = "CT"
}

# variable "service" {
#   default = "CT"
# }

variable "number" {
  default = "01"
}

## Resource name

variable "snstopicname" {
    default = "ME-P-CLOUDTRAIL-SNS-01"
}


variable "logaccountdestination_bucket" {
  default = ""
}