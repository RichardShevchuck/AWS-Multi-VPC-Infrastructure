resource "aws_security_group" "bastion_sg" {
  name   = "bastion-sg"
  vpc_id = var.vpc_bastion
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block_ingress]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_block_egress]
  }
  tags = {
    Name        = "bastion-sg"
    Environment = var.environment
  }
}


resource "aws_security_group" "alb_security_group" {
  name   = "alb-sg"
  vpc_id = var.vpc_alb
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block_ingress]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block_ingress]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_block_egress]
  }
  tags = {
    Name        = "alb-sg"
    Environment = var.environment
  }
}

resource "aws_security_group" "app_sg" {
  name   = "app-sg"
  vpc_id = var.vpc_alb
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_security_group.id]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_bastion_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "app-sg"
    Environment = var.environment
  }
}
