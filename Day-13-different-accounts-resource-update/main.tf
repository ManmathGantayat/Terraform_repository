#if different account resource neec to be create then we need to be configure different accounts key
#like aws configure --profile dev {as after run the command key must be provide}
#IAM user has to be create ,AWS console need to be provide, in that IAM_user Access Key should be generate

resource "aws_s3_bucket" "name" {
    bucket = "ftcywgvwiis" # this resource will create default region
  
}

resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16" # this resource will create us-wast-2 region
    provider = aws.test
    tags = {
        Name = "myvpc"
    }
  
}