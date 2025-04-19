resource "aws_instance" "free_tier_instance" {
    # ami = "ami-084568db4383264d4"
    instance_type = "t3.micro"

    tags = {
        Name = "${var.project}-free-tier-instance"
    }

    key_name = aws_key_pair.aws_ssh_key_free_tier_instance.key_name

    vpc_security_group_ids = [aws_security_group.free_tier_instance_sg.id]

    ami = "ami-0f9de6e2d2f067fca"
}

resource "aws_security_group" "free_tier_instance_sg" {
    name = "${var.project}-free-tier-instance-sg"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 8333
        to_port = 8333
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 18333
        to_port = 18333
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

}

resource "tls_private_key" "ssh_key_free_tier_instance" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "local_file" "ssh_key_free_tier_instance" {
    content = tls_private_key.ssh_key_free_tier_instance.private_key_pem
    filename = "${path.module}/ssh-key-free-tier-ec2.pem"
}

resource "aws_key_pair" "aws_ssh_key_free_tier_instance" {
    key_name = "ssh-key-free-tier-instance"
    public_key = tls_private_key.ssh_key_free_tier_instance.public_key_openssh
}