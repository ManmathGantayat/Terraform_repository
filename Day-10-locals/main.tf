resource "aws_instance" "name" {
   ami = local.ami
   instance_type = local.instance_type
   tags = {
    Name = "ec2"
   }

}

locals {
  instance_type = "t3.micro"
  ami = "ami-07ff62358b87c7116"
}