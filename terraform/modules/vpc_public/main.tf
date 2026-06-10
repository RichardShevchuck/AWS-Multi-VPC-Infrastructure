resource "aws_vpc" "bastion" {
  cidr_block = var.vpc_bastion_cidr
  tags = {
    Name        = var.vpc_bastion_name
    Environment = var.environment
  }

}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.bastion.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name        = "${var.vpc_bastion_name}-public-${count.index + 1}"
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "bastion_igw" {
  vpc_id = aws_vpc.bastion.id
  tags = {
    Name        = "${var.vpc_bastion_name}-igw"
    Environment = var.environment
  }
}


resource "aws_route_table" "bastion_public_rt" {
  vpc_id = aws_vpc.bastion.id
  tags = {
    Name        = "${var.vpc_bastion_name}-public-rt"
    Environment = var.environment
  }
}

resource "aws_route" "bastion_igw_route" {
  route_table_id         = aws_route_table.bastion_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.bastion_igw.id
}

resource "aws_route_table_association" "public_subnet_assoc" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.bastion_public_rt.id
}


