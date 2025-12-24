output "vpc_id" {
  description = "vpc id"
  value = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "VPC CIDR block"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "internet_gateway_id" {
  description = "Internet gateway id"
  value       = aws_internet_gateway.main.id
}

output "nat_gateway_ids" {
  description = "Nat gateway ids"
  value = [for nat in aws_nat_gateway.main : nat.id]
}