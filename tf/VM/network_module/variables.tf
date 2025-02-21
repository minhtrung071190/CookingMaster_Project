variable "location" {
  type    = string
  default = "eastus"
}

variable "vpc_cidr" {
  type = map(any)
}

variable "subnet_cidr" {
  type = map(any)
}

variable "bastion_subnet_cidr" {
  type    = string
}

variable "vpc_name" {
  type = map(any)
}
variable "subnet_name" {
  type = map(any)
}

