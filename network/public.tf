resource "aws_subnet" "public_us_east_1a" {
    vpc_id = aws_vpc.k8svpc.id
    cidr_block = "10.0.64.0/19"

    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true

    tags = {
        name = "public-us-east-1a"
        "kubernetes.io/role/elb" = "1"
        "kubermetes.io/role/eks" = "owned"
    }
}

resource "aws_subnet" "public_us_east_1b" {
    vpc_id = aws_vpc.k8svpc.id
    cidr_block = "10.0.96.0/19"

    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true

    tags = {
        name = "public-us-east-1b"
        "kubernetes.io/role/elb" = "1"
        "kubermetes.io/role/eks" = "owned"
    }
}

resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.k8svpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.k8svpc_igw.id
    }

    tags = {
        name = "public-route-table"
    }
}

resource "aws_route_table_association" "public_us_east_1a" {
    subnet_id = aws_subnet.public_us_east_1a.id
    route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_us_east_1b" {
    subnet_id = aws_subnet.public_us_east_1b.id
    route_table_id = aws_route_table.public_route_table.id
}

output "public_az1_id" {
    value = aws_subnet.public_us_east_1a.id
}

output "public_az2_id" {
    value = aws_subnet.public_us_east_1b.id
}