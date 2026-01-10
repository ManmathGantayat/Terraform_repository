resource "aws_instance" "name" {
   ami = "ami-07ff62358b87c7116"
   instance_type = "t3.micro"
   tags = {
    Name = "ec2"
   }
  
}

resource "aws_s3_bucket" "name" {
    bucket = "terraform-s3test02"
  
}
resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.name.id
  versioning_configuration {
    status = "Enabled"
  }
}