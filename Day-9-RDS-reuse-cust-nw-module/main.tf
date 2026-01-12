module "RDS" {
    source = "../Day-9-cust-network-rds-module"
    vpc_cidr =  "10.0.0.0/16"

    SN1 = {
        cidr = "10.0.0.0/24"
        az = "us-east-1a"
    }
    SN2 = {
      cidr = "10.0.1.0/24"
      az = "us-east-1b"
    }
    route_cidr = "0.0.0.0/0"
    route_table_name = "Public_RT"
    private_route_table_name  = "Private_RT"
    sg_name = "allow_tls"
    #vpc_id  = aws_vpc.name.id
    ingress_rules = [
    {
      description = "HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "All Traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  tags = {
    Name        = "Cust_SG"
    
  }
  db_subnet_group_name = "my_cust_subnet"
  db_name                 = "mydb"
db_identifier           = "rds-test"
db_username             = "admin"
# db_password             = "Cloud123"
#db_subnet_group_name    = "my_cust_subnet"

  
}