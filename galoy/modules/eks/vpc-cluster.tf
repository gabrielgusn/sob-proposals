resource "aws_vpc" "cluster_vpc" {
    cidr_block = "10.21.0.0/16"

    enable_dns_support = true
    enable_dns_hostnames = true
    
    tags = {
        Name = "${var.cluster_name}-vpc"
    }

}

resource "aws_subnet" "private_subnet_az1" {
    vpc_id = aws_vpc.cluster_vpc.id
    cidr_block = "10.21.10.0/24"
    availability_zone = var.zone1
    map_public_ip_on_launch = true
    
    tags = {
        Name = "${var.cluster_name}-prv-sn-${var.zone1}"
        "kubernetes.io/role/internal-elb" = "1"
        "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    }

    depends_on = [
        aws_vpc.cluster_vpc
    ]
}

resource "aws_subnet" "private_subnet_az2" {
    vpc_id = aws_vpc.cluster_vpc.id
    cidr_block = "10.21.20.0/24"
    availability_zone = var.zone2
    map_public_ip_on_launch = true
    
    tags = {
        Name = "${var.cluster_name}-prv-sn-${var.zone2}"
        "kubernetes.io/role/internal-elb" = "1"
        "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    }

    depends_on = [
        aws_vpc.cluster_vpc
    ]
}

resource "aws_subnet" "public_subnet_az1" {
    vpc_id = aws_vpc.cluster_vpc.id
    cidr_block = "10.21.11.0/24"
    availability_zone = var.zone1
    map_public_ip_on_launch = true
    
    tags = {
        Name = "${var.cluster_name}-pub-sn-${var.zone1}"
        "kubernetes.io/cluster/${var.cluster_name}" = "owned"
        "kubernetes.io/role/elb" = 1
    }

    depends_on = [
        aws_vpc.cluster_vpc
    ]
}

resource "aws_subnet" "public_subnet_az2" {
    vpc_id = aws_vpc.cluster_vpc.id
    cidr_block = "10.21.21.0/24"
    availability_zone = var.zone2
    map_public_ip_on_launch = true

    tags = {
        Name = "${var.cluster_name}-pub-sn-${var.zone2}"
        "kubernetes.io/cluster/${var.cluster_name}" = "owned"
        "kubernetes.io/role/elb" = 1
    }

    depends_on = [
        aws_vpc.cluster_vpc
    ]
}


# not privisioning NAT gateway because of costs, but it would be something like:
/* 
resource "aws_eip" "cluster_eip" {
    tags = {
        Name = "${var.cluster_name}-ngw-eip"
    }
}

resource "aws_nat_gateway" "cluster_ngw" {
    subnet_id = aws_subnet.public_subnet_az1.id
    allocation_id = aws_eip.cluster_eip.id

    tags = {
        Name = "${var.cluster_name}-ngw"
    }
}

output "nat_ip" {
    value = aws_nat_gateway.cluster_ngw.public_ip
}

# and also we would need to point this NAT Gateway on the private route table
*/

resource "aws_internet_gateway" "cluster_igw" {
    vpc_id = aws_vpc.cluster_vpc.id

    tags = {
        Name = "${var.cluster_name}-igw"
    }

    depends_on = [
        aws_vpc.cluster_vpc
    ]
}
