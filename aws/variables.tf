variable "AWS_REGION" {
  description   = "AWS region to create instance"
  default       = "ap-northeast-2"
}

variable "AWS_ACCESS_KEY_ID" {
  description   = "AWS access key ID"
}

variable "AWS_SECRET_ACCESS_KEY" {
  description   = "AWS access secret"
}

variable "PUBLIC_KEY" {
  description   = "SSH public key to login into instance"
  type          = string
}


variable "ENV" {
  description   = "Prefix of all AWS resource names the stack created"
  default       = "tech-challenge-syd"
}

variable "allowlist_bastion" {
  description   = "Allowlist network for Bastion host ssh access allowing"
  default       = ["0.0.0.0/0"]
}

variable "az1" {
  default       = "ap-southeast-2a"
}

variable "az2" {
  default       = "ap-southeast-2b"
}

variable "availability_zones" {
  type          = list(string)
  default       = ["ap-southeast-2a", "ap-southeast-2b"]
}

variable "ami_web" {
  description   = "AMI image for webapp node"
  default       = "ami-0d767dd04ac152743"
}

variable "ami_bastion" {
  description   = "AMI image for bastion host"
  default       = "ami-0d767dd04ac152743"
}

variable "instance_type_web" {
  description   = "Webapp instance type"
  default       = "t2.micro"
}

variable "instance_type_bastion" {
  description   = "Bastion host instance type"
  default       = "t2.micro"
}

variable "instance_type_db" {
  description   = "Database instance type"
  default       = "db.t3.medium"
}

variable "PGUSER" {
  description   = "PostgreSQL username"
}

variable "PGPASS" {
  description   = "PostgreSQL password"
}

variable "DBNAME" {
  description   = "PostgreSQL Database Name"
}
