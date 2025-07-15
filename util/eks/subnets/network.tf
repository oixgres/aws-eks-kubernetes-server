variable "region" {
    type = string
}

resource "aws_vpc" "k8s" {
    cidr_block = "10.0.0.0/16"

    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = "k8s"
    }
}

resource "aws_internet_gateway" "k8s" {
    vpc_id = aws_vpc.k8s.id

    tags = {
        Name = "k8s"
    }
}

resource "aws_eip" "k8s" {
    domain = "vpc"
    tags = {
        Name = "nat"
    }
}

resource "aws_nat_gateway" "k8s" {
    allocation_id = aws_eip.k8s.id
    subnet_id = aws_subnet.public1.id

    tags = {
        Name = "k8s"
    }

    depends_on = [ aws_internet_gateway.k8s ]
}

output "subnets" {
    value = [
        aws_subnet.public1.id,
        aws_subnet.public2.id,
        aws_subnet.private1.id,
        aws_subnet.private2.id
    ]
}

output "vpc_id" {
    value = aws_vpc.k8s.id
}