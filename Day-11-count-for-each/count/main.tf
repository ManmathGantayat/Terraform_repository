# resource "aws_instance" "name" {
#     ami = "ami-068c0051b15cdb816"
#     instance_type = "t3.micro"
#     count = 2
#     # tags = {
#     #     Name = " EC_instance"
#     # }
#     tags = {
#       Name = "EC_instance-${count.index}"
#     }
  
# }
### Count function is has a drawback such as if u remove any instance index count from last [2,1,0...]
### it is not follow the Name as remove the instance based on name.
variable "env" {
    type = list(string)
    default = [ "dev","test" ,"prod"]
  
}

resource "aws_instance" "name" {
    ami = "ami-068c0051b15cdb816"
    instance_type = "t3.micro"
    count = length(var.env)
    tags = {
      Name = var.env[count.index]
    }
  
}