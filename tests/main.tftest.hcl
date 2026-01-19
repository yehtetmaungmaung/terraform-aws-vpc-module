run "setup" {
    module {
        source = "./"
    }
}

run "vpc_creation" {
    command = apply

    variables {
        name            = "test-vpc"
        cidr            = "10.0.0.0/16"
        azs             = ["us-east-1a", "us-east-1b"]
        public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
        private_subnets = ["10.0.11.0/24", "10.0.12.0/24"]
        create_igw      = true
    }

    assert {
        condition     = aws_vpc.this.cidr_block == "10.0.0.0/16"
        error_message = "VPC CIDR block should be 10.0.0.0/16"
    }

    assert {
        condition     = aws_vpc.this.enable_dns_hostnames == true
        error_message = "DNS hostnames should be enabled"
    }

    assert {
        condition     = length(aws_subnet.public) == 2
        error_message = "Should have 2 public subnets"
    }

    assert {
        condition     = length(aws_subnet.private) == 2
        error_message = "Should have 2 private subnets"
    }

    assert {
        condition     = aws_internet_gateway.this[0].vpc_id == aws_vpc.this.id
        error_message = "IGW should be attached to VPC"
    }
}

run "nat_gateway_single" {
    command = apply

    variables {
        name             = "test-vpc-nat"
        cidr             = "10.1.0.0/16"
        azs              = ["us-east-1a", "us-east-1b"]
        public_subnets  = ["10.1.1.0/24", "10.1.2.0/24"]
        private_subnets = ["10.1.11.0/24", "10.1.12.0/24"]
        enable_nat_gateway = true
        single_nat_gateway = true
    }

    assert {
        condition     = length(aws_nat_gateway.this) == 1
        error_message = "Should have 1 NAT gateway when single_nat_gateway is true"
    }

    assert {
        condition     = length(aws_eip.nat) == 1
        error_message = "Should have 1 EIP for NAT gateway"
    }
}

run "routing_tables" {
    command = apply

    variables {
        name             = "test-vpc-rt"
        cidr             = "10.2.0.0/16"
        azs              = ["us-east-1a", "us-east-1b"]
        public_subnets  = ["10.2.1.0/24", "10.2.2.0/24"]
        private_subnets = ["10.2.11.0/24", "10.2.12.0/24"]
        create_igw       = true
    }

    assert {
        condition     = length(aws_route_table.public) >= 1
        error_message = "Should have at least 1 public route table"
    }

    assert {
        condition     = length(aws_route_table_association.public) == 2
        error_message = "Should have route table associations for all public subnets"
    }
}