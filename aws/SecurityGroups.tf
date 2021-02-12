resource "aws_security_group" "bastion_sg1" {
    name        = "${var.ENV}-bastion_sg1"
    description = "Bastion Security Group"
    vpc_id      = aws_vpc.vpc1.id

    ingress {
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        cidr_blocks     = var.allowlist_bastion
    }
    egress {
        from_port       = 0
        to_port         = 65535
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }
    tags = {
        Name = "Bastion Security Group"
    }
}

resource "aws_security_group" "web_sg1" {
    name        = "${var.ENV}-web_sg1"
    description = "WebApp node Security Group"
    vpc_id      = aws_vpc.vpc1.id

    ingress {
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        #security_groups = [aws_security_group.bastion_sg1.id]
        cidr_blocks     = ["0.0.0.0/0"]
    }
    ingress {
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }
    egress {
        from_port       = 0
        to_port         = 65535
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }
    tags = {
        Name = "WebApp node Security Group"
    }
}

resource "aws_security_group" "elb_sg1" {
    name        = "${var.ENV}-elb_sg1"
    description = "ELB Security Group"
    vpc_id      = aws_vpc.vpc1.id

    ingress {
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }
    egress {
        from_port       = 0
        to_port         = 65535
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }
    tags = {
        Name = "ELB Security Group"
    }
}


resource "aws_security_group" "rds_sg1" {
    name        = "${var.ENV}-rds_sg1"
    description = "RDS Security Group"
    vpc_id      = aws_vpc.vpc1.id

    ingress {
        from_port       = 5432
        to_port         = 5432
        protocol        = "tcp"
        security_groups = [aws_security_group.bastion_sg1.id, aws_security_group.web_sg1.id]
    }
    egress {
        from_port       = 0
        to_port         = 65535
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }
    tags = {
        Name = "WebApp node Security Group"
    }
}
