resource "aws_subnet" "private_us_east_1a" {
    vpc_id = aws_vpc.k8svpc.id
    cidr_block = "10.0.0.0/19"

    availability_zone = "us-east-1a"
    tags = {
        name = "private_us_east_1a"
        "kubernetes.io/role/internal-elb" = "1"
        "kubernetes.io/cluster/eks" = "owned"
    }
}

resource "aws_subnet" "private_us_east_1b" {
    vpc_id = aws_vpc.k8svpc.id
    cidr_block = "10.0.32.0/19"

    availability_zone = "us-east-1b"
    tags = {
        name = "private_us_east_1b"
        "kubernetes.io/role/internal-elb" = "1"
        "kubernetes.io/cluster/eks" = "owned"
    }
}

resource "aws_route_table" "private_route_table" {
    vpc_id = aws_vpc.k8svpc.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.k8s_nat.id
    }

    tags = {
        name = "private-route-table"
    }
}

resource "aws_route_table_association" "private_us_east_1a" {
    subnet_id = aws_subnet.private_us_east_1a.id
    route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_us_east_1b" {
    subnet_id = aws_subnet.private_us_east_1b.id
    route_table_id = aws_route_table.private_route_table.id
}

output "private_az1_id" {
    value = aws_subnet.private_us_east_1a.id
}

output "private_az2_id" {
    value = aws_subnet.private_us_east_1b.id
}