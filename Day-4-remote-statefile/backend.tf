terraform {
  backend "s3" {
    bucket = "terraform-s3test02"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
