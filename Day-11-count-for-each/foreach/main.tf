variable "env" {
    type = list(string)
    default = [ "dev","test" ,"prod"]
  
}

resource "aws_instance" "name" {
    ami = "ami-068c0051b15cdb816"
    instance_type = "t3.micro"
    #count = length(var.env)
    for_each = toset(var.env) # toset not follow any order like list ( index )
    tags = {
      Name= each.value
    }
  
}