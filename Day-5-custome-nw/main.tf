#Creation of Cust VPC
resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "CUST_VPC"
    }
}
#Creation of Public Subnets
resource "aws_subnet" "sn1" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-1a"
    #map_public_ip_on_launch = true
    tags = {
      Name = "Public SN"
    }
}
#Creation of Private Subnets
resource "aws_subnet" "sn2" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1b"
    tags = {
      Name = "Private SN"
    }
}

#Create the IG & Attach to VPC
resource "aws_internet_gateway" "IGW" {
    vpc_id = aws_vpc.name.id
    tags = {
      Name = "CUST_IG"
    }
}
#Create the Public Route table
resource "aws_route_table" "rt1" {
    vpc_id = aws_vpc.name.id
    tags = {
      Name = "Public RT"
    }
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.IGW.id
    }
}
#Public RT Association
resource "aws_route_table_association" "p_rt_association" {
    subnet_id = aws_subnet.sn1.id
    route_table_id = aws_route_table.rt1.id
  
}



#Create the Private Route table
resource "aws_route_table" "rt2" {
    vpc_id = aws_vpc.name.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat.id
    }
    tags = {
      Name = "Private RT"
    }
}

#Private RT Association
resource "aws_route_table_association" "pvt_ssociation" {
    subnet_id = aws_subnet.sn2.id
    route_table_id = aws_route_table.rt2.id
  
}

# Create the Secusrity Sroup
resource "aws_security_group" "pub_sg" {
    name = "allow_tls"
    vpc_id = aws_vpc.name.id
    tags = {
        Name = "Cust_SG"
    }
    ingress  {
        description = "HTTP"
        from_port   = 80
        to_port     = 80
        protocol    ="TCP"
        cidr_blocks  = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port   = 0
        protocol  = "-1"
        cidr_blocks= ["0.0.0.0/0"]
    }
  
}

#Create the EC2 instance
resource "aws_instance" "name" {
    ami=var.ami_id
    instance_type = var.instance_type
    subnet_id = aws_subnet.sn1.id
    vpc_security_group_ids = [aws_security_group.pub_sg.id]
    #map_public_ip_on_launch = true

    tags = {
    Name = "DEV"
  }
}

resource "aws_eip" "eip" {
  domain = "vpc"

  tags = {
    Name = "nat-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.sn1.id

  tags = {
    Name = "CUST_NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.IGW]
}