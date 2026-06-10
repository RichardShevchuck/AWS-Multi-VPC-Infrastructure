resource "aws_ec2_transit_gateway" "main" {
  description = "Transit Gateway for VPC connectivity"
  tags = {
    Name        = "main-tgw"
    Environment = var.environment
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "bastion" {
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id             = var.vpc_bastion_id
  subnet_ids         = [var.vpc_bastion_subnet_id]
  tags = {
    Name        = "tgw-bastion-attach"
    Environment = var.environment
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "private" {
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id             = var.vpc_private_id
  subnet_ids         = [var.vpc_private_subnet_id]
  tags = {
    Name        = "tgw-private-attach"
    Environment = var.environment
  }
}

resource "aws_route" "bastion_to_private" {
  route_table_id         = var.bastion_route_table_id
  destination_cidr_block = var.vpc_private_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id
}

resource "aws_route" "private_to_bastion" {
  route_table_id         = var.private_route_table_id
  destination_cidr_block = var.vpc_bastion_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.main.id
}
