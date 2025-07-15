resource "aws_subnet" "private1" {
    vpc_id = aws_vpc.k8s.id
    cidr_block = "10.0.0.0/19"

    availability_zone = "${var.region}a"
    tags = {
        Name = "private-${var.region}a"
        "kubernetes.io/role/internal-elb" = "1"
        "kubernetes.io/cluster/eks" = "owned"
    }
}

resource "aws_subnet" "private2" {
    vpc_id = aws_vpc.k8s.id
    cidr_block = "10.0.32.0/19"

    availability_zone = "${var.region}b"
    tags = {
        Name = "private-${var.region}b"
        "kubernetes.io/role/internal-elb" = "1"
        "kubernetes.io/cluster/eks" = "owned"
    }
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.k8s.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.k8s.id
    }

    tags = {
        Name = "k8s-private"
    }
}

resource "aws_route_table_association" "private1" {
    subnet_id = aws_subnet.private1.id
    route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private2" {
    subnet_id = aws_subnet.private2.id
    route_table_id = aws_route_table.private.id
}
