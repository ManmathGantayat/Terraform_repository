resource "aws_instance" "name" {
   ami = "ami-07ff62358b87c7116"
   instance_type = "t3.micro"
   tags = {
    Name = "ec2"
   }
#    lifecycle {
#      prevent_destroy = true
#    }
# lifecycle {
#   ignore_changes = [ tags ]
# }
# lifecycle {
#   create_before_destroy = true
# }

  
}