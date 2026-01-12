variable "vpc_cidr" {
    description = "Cust cidr block vpc"
    type = string
  
}
variable "SN1" {
    description = "Public sn config"
    type = object({
      cidr = string
      az =string
    })
    
  
}
variable "SN2" {
    description = "Public sn config"
    type = object({
      cidr = string
      az =string
    })  
  
}
variable "route_cidr" {
    description = "Destination CIDR for the route"
    type = string
  
}
variable "route_table_name" {
    description = "Name tag for the route table"
    type = string
  
}
variable "private_route_table_name" {
  description = "Name tag for private route table"
  type        = string
}
variable "sg_name" {
  description = "Security group name"
  type        = string
}
variable "ingress_rules" {
  description = "Ingress rules for the security group"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}
variable "egress_rules" {
  description = "Egress rules for the security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}
variable "tags" {
  description = "Common tags"
  type        = map(string)
}
# variable "db_subnet_group_name" {
#     description = "DB subnet group name"
#     type = string
  
# }

#RDS-------
variable "allocated_storage" {
  description = "Allocated storage in GB for RDS"
  type        = number
  default     = 10
}

variable "db_name" {
  description = "Initial database name"
  type        = string
}

variable "db_identifier" {
  description = "RDS instance identifier"
  type        = string
}

variable "engine" {
  description = "Database engine"
  type        = string
  default     = "mysql"
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
  default     = "8.0"
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_username" {
  description = "Master username for RDS"
  type        = string
}

# variable "db_password" {
#   description = "Master password for RDS"
#   type        = string
#   sensitive   = true
# }

variable "db_subnet_group_name" {
  description = "DB subnet group name"
  type        = string
}

variable "parameter_group_name" {
  description = "DB parameter group name"
  type        = string
  default     = "default.mysql8.0"
}

variable "backup_retention_period" {
  description = "Number of days to retain backups"
  type        = number
  default     = 1
}

variable "backup_window" {
  description = "Preferred backup window (UTC)"
  type        = string
  default     = "02:00-03:00"
}

variable "maintenance_window" {
  description = "Preferred maintenance window (UTC)"
  type        = string
  default     = "sun:04:00-sun:05:00"
}

variable "deletion_protection" {
  description = "Enable deletion protection for RDS"
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot on deletion"
  type        = bool
  default     = true
}

variable "apply_immediately" {
  description = "Apply changes immediately"
  type        = bool
  default     = true
}
# variable "read_replica_instance_class" {
#   description = "Instance class for RDS read replica"
#   type        = string
#   default     = "db.t3.micro"
# }




