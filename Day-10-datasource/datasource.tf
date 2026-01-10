#create a data block for VPC
data "aws_vpc" "name" {
    filter {
      name = "tag:Name"
      values = ["CUST_VPC"]
    }
  
}

#create data block for public subnet
data "aws_subnet" "pub_sn_block" {
    filter {
      name = "tag:Name"
      values = ["Public SN"]
    }
  
}

#create a datablock for private subnet
data "aws_subnet" "pvt_sn_block" {
    filter {
      name = "tag:Name"
      values = ["Private SN"]
    }
  
}
#create datasource for IGW
data "aws_internet_gateway" "name" {
    filter {
      name = "tag:Name"
      values = ["CUST_IG"]
    }
}
#create datasource for public RT
data "aws_route_table" "pub_rt" {
    filter {
      name = "tag:Name"
      values = ["Public RT"]
    }
  
}
#create datasource for AMI to create ec2
data "aws_ami" "amzlinux" {
  most_recent = false
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.20231101.0-x86_64-gp2"]
  }
}
