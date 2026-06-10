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


module "iam" {
  source = "./modules/iam"
}

resource "aws_key_pair" "bastion_key" {
  key_name   = "bastion-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

module "bastion" {
  source               = "./modules/bastion"
  subnet_id            = module.vpc_public.bastion_subnet_id
  security_group_id    = module.security_groups.bastion_security_group_id
  key_pair_name        = aws_key_pair.bastion_key.key_name
  iam_instance_profile = module.iam.instance_profile_name
}

module "launch_template" {
  source                    = "./modules/launch-template"
  security_group_id         = module.security_groups.app_sg_id
  iam_instance_profile_name = module.iam.instance_profile_name
  key_name                  = aws_key_pair.bastion_key.key_name
}


module "app_auto_scaling_group" {
  source = "./modules/asg"

  launch_template_id = module.launch_template.launch_template_id
  subnet_ids = [
    module.vpc_private.private_subnet_id0,
    module.vpc_private.private_subnet_id1
  ]
}
