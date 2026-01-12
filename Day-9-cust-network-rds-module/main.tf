resource "aws_vpc" "name" {
    cidr_block = var.vpc_cidr
    tags = {
        Name ="CUST_VPC"
    }
  
}
#Creation of Public Subnets
resource "aws_subnet" "SN1" {
    vpc_id = aws_vpc.name.id
    cidr_block = var.SN1.cidr
    availability_zone = var.SN1.az
    tags = {
      Name = "Public_SN"
    }
  
}
#Creation of Private Subnets
resource "aws_subnet" "SN2" {
    vpc_id = aws_vpc.name.id
    cidr_block = var.SN2.cidr
    availability_zone = var.SN2.az
    tags = {
      Name = "Private_SN"
    }
  
}
resource "aws_internet_gateway" "IGW" {
    vpc_id = aws_vpc.name.id
    tags = {
      Name = "CUST_IG"
    }
  
}
resource "aws_route_table" "RT1" {
    vpc_id = aws_vpc.name.id
    route {
        cidr_block = var.route_cidr
        gateway_id = aws_internet_gateway.IGW.id
    }
    tags = {
      Name = var.route_table_name
    }
}
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.SN1.id
  route_table_id = aws_route_table.RT1.id
}
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.SN1.id

  depends_on = [aws_internet_gateway.IGW]

  tags = {
    Name = "NAT-GW"
  }
}
resource "aws_route_table" "RT2" {
    vpc_id = aws_vpc.name.id
    route {
        cidr_block = var.route_cidr
        nat_gateway_id = aws_nat_gateway.nat.id
    }
    tags = {
      Name = var.private_route_table_name
    }
}
resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.SN2.id
  route_table_id = aws_route_table.RT2.id
}
resource "aws_security_group" "pub_sg" {
  name   = var.sg_name
  vpc_id = aws_vpc.name.id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = var.tags
}
resource "aws_db_subnet_group" "sub_grp" {
    name = var.db_subnet_group_name
    subnet_ids = [
        aws_subnet.SN1.id,
        aws_subnet.SN2.id
    ]
    # subnet_ids = var.subnet_ids
    # tags = {
    #   Name = var.tags
    # }
    tags = merge(
        var.tags,
        {
            Name = var.db_subnet_group_name
        }
    )
  
}
#RDS-----
resource "aws_db_instance" "default" {
  allocated_storage    = var.allocated_storage
  db_name              = var.db_name
  identifier           = var.db_identifier
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  
#   username             = var.db_username
#   password             = var.db_password
#   username = local.db_creds.username
#   password = local.db_creds.password
    username            = var.db_username
    manage_master_user_password = true

  db_subnet_group_name = var.db_subnet_group_name
  parameter_group_name = var.parameter_group_name

  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window

  deletion_protection  = var.deletion_protection
  skip_final_snapshot  = var.skip_final_snapshot
  apply_immediately    = var.apply_immediately
}
resource "aws_secretsmanager_secret" "rds_secret" {
  name        = "rds/mysql/admin"
  description = "RDS MySQL admin credentials"
}

# resource "aws_secretsmanager_secret_version" "rds_secret_value" {
#   secret_id = aws_secretsmanager_secret.rds_secret.id

#   secret_string = jsonencode({
#     username = var.db_username
#     password = var.db_password
#   })
# }

#Created the read replica but some error will try after some time
# resource "aws_db_instance" "read_replica" {
#   identifier = "${var.db_identifier}-rr"

#   replicate_source_db = aws_db_instance.default.identifier

#   instance_class = var.read_replica_instance_class

#   publicly_accessible = false

#   depends_on = [
#     aws_db_instance.default
#   ]

#   tags = merge(
#     var.tags,
#     {
#       Name = "${var.db_identifier}-read-replica"
#     }
#   )
# }







