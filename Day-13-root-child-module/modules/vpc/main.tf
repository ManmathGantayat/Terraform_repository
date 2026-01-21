resource "aws_vpc" "cust_vpc" {
    cidr_block = var.cidr_block
}

resource "aws_subnet" "SN1" {
    vpc_id = aws_vpc.cust_vpc.id
    cidr_block = var.subnet_1_cidr
    availability_zone = var.az1
}

resource "aws_subnet" "SN2" {
    vpc_id = aws_vpc.cust_vpc.id
    cidr_block = var.subnet_2_cidr
    availability_zone = var.az2
}

output "subnet_1_id" {
    value = "${aws_subnet.SN1.id}"
}

output "subnet_2_id" {
  value = "${aws_subnet.SN2.id}"
}