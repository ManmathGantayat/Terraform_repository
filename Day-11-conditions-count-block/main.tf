provider "aws" {
  
}
# variable "create_ec2" {
#   type    = bool
#   default = false
# }

# resource "aws_instance" "app" {
#   count = var.create_ec2 ? 1 : 0

#   ami           = "ami-068c0051b15cdb816"
#   instance_type = "t2.micro"
# }


variable "azs" {
  default = ["ap-south-1a", "ap-south-1b"]
}

resource "aws_subnet" "public" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index}.0/24" #cidr count from 10.0.0.0/24 & 10.0.1.0/24
  availability_zone = var.azs[count.index] # az count will be 1a & 1b

  tags = {
    Name = "public-${count.index}"
  }
}