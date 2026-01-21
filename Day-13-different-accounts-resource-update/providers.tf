provider "aws" {
  
   
}
provider "aws" {
    region = "us-west-2"
    alias = "test"
    profile = "dev" # this profile is different account key {aws configure --profile dev}
  
}