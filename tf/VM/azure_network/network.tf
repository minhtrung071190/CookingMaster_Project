module "network" {
  source = ".\network_module"
  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr
  subnet_cidr = var.subnet_cidr
}