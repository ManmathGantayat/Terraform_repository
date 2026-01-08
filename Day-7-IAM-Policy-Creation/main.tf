# Create a Custome Policy
resource "aws_iam_policy" "name" {
    name = "CUST_Policy"
    
    policy = jsonencode({
        Version = "2012-10-17"
        Statement =[
            {
                Effect = "Allow"
                Action = [
                    "s3:GetObject",
                    "s3:PutObject"
                ]
                "Resource": "*"
            }
        ]
    })
  
}

#Create a Custome Role
resource "aws_iam_role" "iam_role" {
  name = "CUST_Lambda_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

}

#Attach the custome policy to custome role
resource "aws_iam_policy_attachment" "name" {
    name = "Policy-attachment"
    policy_arn = aws_iam_policy.name.arn
    roles = [aws_iam_role.iam_role.name]
  
}

#Create the s3 bucket
resource "aws_s3_bucket" "name" {
  bucket = "terraform-s3test04"

}

#Upload the object inside the S3 bucket
resource "aws_s3_object" "name" {
    bucket = aws_s3_bucket.name.id
    key = "lambda_function.zip"
    source = "lambda_function.zip"

    etag = filemd5("lambda_function.zip")
  
}

#Create the Lambda Function as my Zip file is calling from the S3 bucket
resource "aws_lambda_function" "my_lambda" {
  function_name = "my_lambda_function"
  role          =  aws_iam_role.iam_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  timeout       = 900
  memory_size   = 128
  #filename = "lambda_function.zip"
  s3_bucket = aws_s3_bucket.name.id
  s3_key = aws_s3_object.name.key

 
  source_code_hash = filemd5("lambda_function.zip")

  #Without source_code_hash, Terraform might not detect when the code in the ZIP file has changed — meaning your Lambda might not update even after uploading a new ZIP.

#This hash is a checksum that triggers a deployment.
}

#create eventbridge rule (schedule)
resource "aws_cloudwatch_event_rule" "name" {
    name = "CUST_event"
    description = "Trigger the lambda every 5 min"
    schedule_expression = "cron(0/5 * * * ? *)"
  
}

resource "aws_cloudwatch_event_target" "add_event_lambda" {
    rule = aws_cloudwatch_event_rule.name.name
    target_id = "lambda"
    arn = aws_lambda_function.my_lambda.arn
  
}

resource "aws_lambda_permission" "name" {
    statement_id  = "AllowExecutionFromEventBridge"
    action        = "lambda:InvokeFunction"
    function_name = aws_lambda_function.my_lambda.function_name
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.name.arn
  
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
