resource "aws_subnet" "public1" {
    vpc_id = aws_vpc.k8s.id
    cidr_block = "10.0.64.0/19"

    availability_zone = "${var.region}a"
    map_public_ip_on_launch = true

    tags = {
        Name = "k8s-public-${var.region}a"
        "kubernetes.io/role/elb" = "1"
        "kubernetes.io/role/eks" = "owned"
    }
}

resource "aws_subnet" "public2" {
    vpc_id = aws_vpc.k8s.id
    cidr_block = "10.0.96.0/19"

    availability_zone = "${var.region}b"
    map_public_ip_on_launch = true

    tags = {
        Name = "k8s-public-${var.region}b"
        "kubernetes.io/role/elb" = "1"
        "kubernetes.io/role/eks" = "owned"
    }
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.k8s.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.k8s.id
    }

    tags = {
        Name = "k8s-public"
    }
}

resource "aws_route_table_association" "public1" {
    subnet_id = aws_subnet.public1.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
    subnet_id = aws_subnet.public2.id
    route_table_id = aws_route_table.public.id
}
