variable "location" {
  type    = string
  default = "eastus"
}

variable "vpc_cidr" {
  default = {
    "vnet1" = "10.0.0.0/16"
    "vnet2" = "172.31.0.0/16"
  }
  type = map(any)
}

variable "subnet_cidr" {
  default = {
    "vnet1-subnet1" = "10.0.0.0/24"
    "vnet2-subnet1" = "172.31.0.0/24"
  }
  type = map(any)
}


variable "vpc_name" {
  default = {
    "vnet1" = "app-vnet1"
    "vnet2" = "app-vnet2"
  }
  type = map(any)
}
variable "subnet_name" {
  default = {
    "vnet1" = "vnet1-subnet1"
    "vnet2" = "vnet2-subnet1"
  }
  type = map(any)
}

