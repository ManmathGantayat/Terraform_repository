resource "aws_instance" "name" {
    ami=var.ami_id
    instance_type = var.instance_type

    tags = {
    Name = "QA"
  }
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket ="s3terraformmtgyfrtsddd"
  
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}