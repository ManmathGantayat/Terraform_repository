variable "ami_id" {
  description = "Passing the ami value to main.tf"
  type = string
  default = ""
}

variable "instance_type" {
    type = string
    default = ""
}

#*variable "key_name" {
  #description = "The name for the AWS Key Pair"
  #type        = string
 # default     = ""
#}

variable "key_name" {
  description = "The name for the AWS Key Pair"
  type        = string
  default     = "my-deployer-key"
}

variable "public_key_path" {
  description = "Path to the local public key file"
  type        = string
  default     = ""
}