data "aws_vpc" "default" {
  default = true
}

# Delete default sg rule.
# If egress/ingress is not specified, delete sg rule.
resource "aws_default_security_group" "this" {
  vpc_id = data.aws_vpc.default.id
}

# VPC
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.env}-${var.name}-${var.role}-vpc"
  }
}

# Subnet
## Public
resource "aws_subnet" "public" {
  for_each = var.public_subnets

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = "${var.env}-${var.name}-${each.value.role}"
  }
}

## Private
resource "aws_subnet" "private" {
  for_each = var.private_subnets

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = "${var.env}-${var.name}-${each.value.role}"
  }
}

## DB
resource "aws_subnet" "db" {
  for_each = var.db_subnets

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = "${var.env}-${var.name}-${each.value.role}"
  }
}

# IGW
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.env}-${var.name}-igw"
  }
}

# EIP
resource "aws_eip" "this" {
  for_each = var.public_subnets

  depends_on = [ aws_internet_gateway.this ]

  tags = {
    Name = "${var.env}-${var.name}-${each.value.name}-eip"
  }
}

# NAT
resource "aws_nat_gateway" "this" {
  for_each      = var.public_subnets

  allocation_id = aws_eip.this[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  tags = {
    Name = "${var.env}-${var.name}-${each.value.role}-ng"
  }
}
