
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


###### Resource

variable "internal" {
    default = "true"
}

variable "tgport" {
    default = "80"
}

variable "tgprotocol" {
    default = "HTTP"
}

variable "heathcheck_path" {
    default = "/index.html"
}


variable "lisport" {
    default = "80"
}

variable "lisprotocol" {
    default = "HTTP"
}



variable "APPVpcName" {
    default = ""
}

variable "APPSubnet01Name" {
  default = ""
}

variable "APPSubnet02Name" {
  default = ""
}