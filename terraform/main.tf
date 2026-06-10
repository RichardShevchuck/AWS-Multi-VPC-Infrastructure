terraform {
  required_version = ">= 0.12"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc_public" {
  source = "./modules/vpc_public"
}

module "vpc_private" {
  source = "./modules/vpc_private"
}

module "security_groups" {
  source      = "./modules/security-groups"
  vpc_bastion = module.vpc_public.vpc_bastion_id
  vpc_alb     = module.vpc_private.vpc_alb_id
}

module "transit_gateway" {
  source = "./modules/transit-gateway"

  vpc_bastion_id         = module.vpc_public.vpc_bastion_id
  vpc_bastion_subnet_id  = module.vpc_public.bastion_subnet_id
  bastion_route_table_id = module.vpc_public.bastion_route_table_id

  vpc_private_id         = module.vpc_private.vpc_alb_id
  vpc_private_subnet_id  = module.vpc_private.private_public_subnet_id
  private_route_table_id = module.vpc_private.private_route_table_id
}
