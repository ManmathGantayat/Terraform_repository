variable "ami_id" {
  description = "Passing the ami value to main.tf"
  type = string
  default = ""
}

variable "instance_type" {
    type = string
    default = ""
}