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

# variable "service" {
#   default = "CT"
# }

variable "number" {
  default = "01"
}

## Resource name

variable "snstopicname" {
    default = "ME-P-NS-SNS-01"
}


variable "logaccountdestination_bucket" {
  default = ""
}