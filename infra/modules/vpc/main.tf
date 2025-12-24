resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.Environment_name}-vpc"
  })
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

tags = merge(var.tags, {
    Name = "${var.project_name}-${var.Environment_name}-igw"
  })
}

resource "aws_subnet" "public" {
  count                   = length(var.azs) 
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true


  tags = merge(var.tags,{
    Name = "${var.project_name}-${var.Environment_name}-public-${count.index +1}"
  })
}

resource "aws_subnet" "private" {
  count      = length(var.azs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.Environment_name}-private-${count.index +1}"
    type = "private"
  })
}

resource "aws_eip" "nat" {
  domain   = "vpc"
  depends_on = [ aws_internet_gateway.main ]
  count = length(var.azs)

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.Environment_name}-eip-nat-${count.index +1}"
  })
}

resource "aws_nat_gateway" "main" {
  count = length(var.azs)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id 

 tags = merge(var.tags, {
    Name = "${var.project_name}-${var.Environment_name}-nat-${count.index +1}"
  })

  depends_on = [aws_internet_gateway.main]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.Environment_name}-public-rt"
  })
}

resource "aws_route_table" "private" {
  count = length(var.azs)
  
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.main[count.index].id
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.Environment_name}-private-rt-${count.index +1}"
  })
}

resource "aws_route_table_association" "public" {
  count = length(var.azs)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(var.azs)
  
  subnet_id = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}