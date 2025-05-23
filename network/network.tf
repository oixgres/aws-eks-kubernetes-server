resource "aws_vpc" "k8svpc" {
    cidr_block = "10.0.0.0/16"

    enable_dns_support = true
    enable_dns_hostnames =  true

    tags = {
        name = "k8svpc"
    }
}

resource "aws_internet_gateway" "k8svpc_igw" {
    vpc_id = aws_vpc.k8svpc.id
    tags = {
        name = "k8svpc_igw"
    }
}

resource "aws_eip" "nat_eip" {
    domain = "vpc"
    tags = {
        name = "nat_eip"
    }
}

resource "aws_nat_gateway" "k8s_nat" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id = aws_subnet.public_us_east_1a.id

    tags = {
        name = "k8s_nat"
    }

    depends_on = [ aws_internet_gateway.k8svpc_igw ]
}

