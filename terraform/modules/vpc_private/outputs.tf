output "vpc_alb_id" {
  value = aws_vpc.private.id
}

output "private_public_subnet_id" {
  value = aws_subnet.public[0].id
}

output "private_route_table_id" {
  value = aws_route_table.private_rt.id
}

output "private_subnet_id0" {
  value = aws_subnet.private[0].id
}

output "private_subnet_id1" {
  value = aws_subnet.private[1].id
}

output "private_public_subnet_id1" {
  value = aws_subnet.public[1].id
}
