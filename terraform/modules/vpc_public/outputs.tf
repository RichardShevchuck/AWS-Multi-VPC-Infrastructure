output "vpc_bastion_id" {
  value = aws_vpc.bastion.id
}

output "bastion_subnet_id" {
  value = aws_subnet.public[0].id
}

output "bastion_route_table_id" {
  value = aws_route_table.bastion_public_rt.id
}
