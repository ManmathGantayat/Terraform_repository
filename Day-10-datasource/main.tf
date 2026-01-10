#Important Note First create the resource then call the datablock another resource block
#Creation of Cust VPC
resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "CUST_VPC"
    }
}


#Creation of Public Subnets
resource "aws_subnet" "sn1" {
    vpc_id = data.aws_vpc.name.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
    tags = {
      Name = "Public SN"
    }
}
#Creation of Private Subnets
resource "aws_subnet" "sn2" {
    vpc_id = data.aws_vpc.name.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1b"
    tags = {
      Name = "Private SN"
    }
}



#Create the IG & Attach to VPC
resource "aws_internet_gateway" "IGW" {
    vpc_id = data.aws_vpc.name.id
    tags = {
      Name = "CUST_IG"
    }
}

#Create the Public Route table
resource "aws_route_table" "rt1" {
    vpc_id = data.aws_vpc.name.id
    tags = {
      Name = "Public RT"
    }
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = data.aws_internet_gateway.name.id
    }
}
#Public RT Association
resource "aws_route_table_association" "p_rt_association" {
    subnet_id = data.aws_subnet.pub_sn_block.id
    route_table_id = data.aws_route_table.pub_rt.id
  
}
#Create the Public EC2 instance
resource "aws_instance" "name" {
    ami= data.aws_ami.amzlinux.id
    instance_type = "t3.micro"
    subnet_id = data.aws_subnet.pub_sn_block.id
    #vpc_security_group_ids = [aws_security_group.pub_sg.id]
    #key_name = var.key_name
    #key_name      = aws_key_pair.deployer_key.key_name

    tags = {
    Name = "DEV"
  }
}