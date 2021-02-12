resource "aws_vpc" "vpc1" {
    cidr_block              = "10.0.0.0/16"
    enable_dns_support      = true
    enable_dns_hostnames    = true
    tags = {
        Name                = "${var.ENV}-vpc1"
    }
}

resource "aws_subnet" "pub_subnet1" {
    vpc_id                  = aws_vpc.vpc1.id
    cidr_block              = "10.0.1.0/24"
    availability_zone       = var.az1
    tags = {
        Name                = "${var.ENV}-pub_subnet1"
    }
}

resource "aws_subnet" "pub_subnet2" {
    vpc_id                  = aws_vpc.vpc1.id
    cidr_block              = "10.0.2.0/24"
    availability_zone       = var.az2
    tags = {
        Name                = "${var.ENV}-pub_subnet2"
    }
}

resource "aws_internet_gateway" "internet_gw1" {
    vpc_id                  = aws_vpc.vpc1.id
    tags = {
        Name                = "${var.ENV}-internet_gw1"
    }
}

resource "aws_route_table" "pub_rtb1" {
    vpc_id                  = aws_vpc.vpc1.id
    route {
        cidr_block          = "0.0.0.0/0"
        gateway_id          = aws_internet_gateway.internet_gw1.id
    }
    tags = {
        Name                = "${var.ENV}-pub_rtb1"
    }
}

resource "aws_route_table_association" "rtb_association1" {
    subnet_id               = aws_subnet.pub_subnet1.id
    route_table_id          = aws_route_table.pub_rtb1.id
}

resource "aws_route_table_association" "rtb_association2" {
    subnet_id               = aws_subnet.pub_subnet2.id
    route_table_id          = aws_route_table.pub_rtb1.id
}


resource "aws_subnet" "db_subnet1" {
    vpc_id                  = aws_vpc.vpc1.id
    cidr_block              = "10.0.11.0/24"
    availability_zone       = var.az1
    tags = {
        Name                = "${var.ENV}-db_subnet1"
    }
}

resource "aws_subnet" "db_subnet2" {
    vpc_id                  = aws_vpc.vpc1.id
    cidr_block              = "10.0.12.0/24"
    availability_zone       = var.az2
    tags = {
        Name                = "${var.ENV}-db_subnet2"
    }
}
