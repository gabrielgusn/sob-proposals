resource "aws_route_table" "cluster_prv_rt" {
    vpc_id = aws_vpc.cluster_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        # Here we would be setting the NAT Gateway on a real case
        # gateway_id = aws_nat_gateway.cluster_ngw.id 
        gateway_id = aws_internet_gateway.cluster_igw.id 
    }

    tags = {
        Name = "${var.cluster_name}-rt-prv "
    }

    depends_on = [ 
        aws_vpc.cluster_vpc,
        aws_subnet.private_subnet_az1,
        aws_subnet.private_subnet_az2,
        aws_subnet.public_subnet_az1,
        aws_subnet.public_subnet_az2,
     ]
}

resource "aws_route_table" "cluster_pub_rt" {

    vpc_id = aws_vpc.cluster_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.cluster_igw.id
    }

    tags = {
      Name = "${var.cluster_name}-rt-pub"
    }

    depends_on = [ 
        aws_vpc.cluster_vpc,
        aws_subnet.private_subnet_az1,
        aws_subnet.private_subnet_az2,
        aws_subnet.public_subnet_az1,
        aws_subnet.public_subnet_az2,
     ]

}

resource "aws_route_table_association" "cluster_pub_sn_az1_association" {
    subnet_id = aws_subnet.public_subnet_az1.id
    route_table_id = aws_route_table.cluster_pub_rt.id
    depends_on = [ 
        aws_route_table.cluster_prv_rt,
        aws_route_table.cluster_pub_rt
    ]
}

resource "aws_route_table_association" "cluster_pub_sn_az2_association" {
    subnet_id = aws_subnet.public_subnet_az2.id
    route_table_id = aws_route_table.cluster_pub_rt.id
    depends_on = [ 
        aws_route_table.cluster_prv_rt,
        aws_route_table.cluster_pub_rt
    ]
}

resource "aws_route_table_association" "cluster_prv_sn_az1_association" {
    subnet_id = aws_subnet.private_subnet_az1.id
    route_table_id = aws_route_table.cluster_prv_rt.id
    depends_on = [ 
        aws_route_table.cluster_prv_rt,
        aws_route_table.cluster_pub_rt
    ]
}

resource "aws_route_table_association" "cluster_prv_sn_az2_association" {
    subnet_id = aws_subnet.private_subnet_az2.id
    route_table_id = aws_route_table.cluster_prv_rt.id
    depends_on = [ 
        aws_route_table.cluster_prv_rt,
        aws_route_table.cluster_pub_rt
    ]
}