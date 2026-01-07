terraform {
  backend "s3" {
    bucket = "terraform-s3test02"
    key    = "RDS/terraform.tfstate"
    region = "us-east-1"
    #use_lockfile   = true # Enable S3 native locking
    # Remove 'dynamodb_table' argument if migrating from the legacy method
  }
}