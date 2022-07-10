terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.51"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = var.aws_region
  access_key = ""
  secret_key = ""
}



# Creating VPC

resource "aws_vpc" "web_app_vpc" {
  cidr_block = var.vpc_prefix
  tags = {
    Name = "Web App VPC"
  }
}

# Making IGW for my VPC

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.web_app_vpc.id
}
# Creating Public Subnet 1

resource "aws_subnet" "public_subnet-1" {
  vpc_id = aws_vpc.web_app_vpc.id
  cidr_block = var.public_subnet-1_cidr
  availability_zone = var.availability_zone-1

  tags = {
    Name = "Public Subnet 1"
  }
}

# Creating Private Subnet 1

resource "aws_subnet" "private_subnet-1" {
  vpc_id = aws_vpc.web_app_vpc.id
  cidr_block = var.private_subnet-1_cidr
  availability_zone = var.availability_zone-1

  tags = {
    Name = "Private Subnet 1"
  }
}

# Creating Public Subnet 2

resource "aws_subnet" "public_subnet-2" {
  vpc_id = aws_vpc.web_app_vpc.id
  cidr_block = var.public_subnet-2_cidr
  availability_zone = var.availability_zone-2

  tags = {
    Name = "Public Subnet 2"
  }
}

# Creating Private Subnet 3

resource "aws_subnet" "private_subnet-2" {
  vpc_id = aws_vpc.web_app_vpc.id
  cidr_block = var.private_subnet-2_cidr
  availability_zone = var.availability_zone-2

  tags = {
    Name = "Private Subnet 2"
  }
}
# Creating Private Subnet 2

resource "aws_subnet" "private_subnet-3" {
  vpc_id = aws_vpc.web_app_vpc.id
  cidr_block = var.private_subnet-3_cidr
  availability_zone = var.availability_zone-1

  tags = {
    Name = "Private Subnet 3"
  }
}
# Creating Private Subnet 4

resource "aws_subnet" "private_subnet-4" {
  vpc_id = aws_vpc.web_app_vpc.id
  cidr_block = var.private_subnet-4_cidr
  availability_zone = var.availability_zone-2

  tags = {
    Name = "Private Subnet 4"
  }
}
# Making Public Route Table

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.web_app_vpc.id

  route {
    cidr_block = var.public_route_table_cidr
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

# Making Private Route Table 1

resource "aws_route_table" "private_route_table-1" {
  vpc_id = aws_vpc.web_app_vpc.id

  route {
    cidr_block = var.private_route_table_cidr
    nat_gateway_id = aws_nat_gateway.nat-gateway-1.id
  }

  tags = {
    Name = "Private Route Table 1"
  }
}
# Making Private Route Table 2

resource "aws_route_table" "private_route_table-2" {
  vpc_id = aws_vpc.web_app_vpc.id

  route {
    cidr_block = var.private_route_table_cidr
    nat_gateway_id = aws_nat_gateway.nat-gateway-2.id
  }

  tags = {
    Name = "Private Route Table 2"
  }
}


  # Allocating Elastic IP 1

resource "aws_eip" "eip-for-nat-1" {
  vpc      = true
  tags = {
    Name = "Elastic IP 1"
  }
}

# Allocating Elastic IP 2

resource "aws_eip" "eip-for-nat-2" {
  vpc      = true
  tags = {
    Name = "Elastic IP 2"
  }
}

# Create NAT Gateway 1 in Public Subnet-1

resource "aws_nat_gateway" "nat-gateway-1" {
  allocation_id = aws_eip.eip-for-nat-1.id
  subnet_id = aws_subnet.public_subnet-1.id

  tags = {
    Name = "NAT Gateway Public Subnet 1"
  }
}

# Create NAT Gateway 2 in Public Subnet-2

resource "aws_nat_gateway" "nat-gateway-2" {
  allocation_id = aws_eip.eip-for-nat-2.id
  subnet_id = aws_subnet.public_subnet-2.id

  tags = {
    Name = "NAT Gateway Public Subnet 2"
  }
}
# Associating the Public Subnet 1 with the Public Route Table

resource "aws_route_table_association" "public-subnet-1-route-table-association" {
  subnet_id      = aws_subnet.public_subnet-1.id
  route_table_id = aws_route_table.public_route_table.id
}

# Associating the Private Subnet 1 with the Private Route Table 1

resource "aws_route_table_association" "private-subnet-1-route-table-association" {
  subnet_id      = aws_subnet.private_subnet-1.id
  route_table_id = aws_route_table.private_route_table-1.id
}

# Associating the Public Subnet 2 with the Public Route Table

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.public_subnet-2.id
  route_table_id = aws_route_table.public_route_table.id
}

# Associating the Private Subnet 2 with the Private Route Table 1

resource "aws_route_table_association" "private-subnet-2-route-table-association" {
  subnet_id      = aws_subnet.private_subnet-2.id
  route_table_id = aws_route_table.private_route_table-2.id
}

# Creating Database Subnet group for RDS under our VPC

resource "aws_db_subnet_group" "db_subnet" {
  name       = "rds_db"
  subnet_ids = [aws_subnet.private_subnet-3.id,aws_subnet.private_subnet-1.id,aws_subnet.private_subnet-2.id,aws_subnetaws_subnet.private_subnet-4.id]

  tags = {
    Name = "My DB subnet group"
  }
 }
