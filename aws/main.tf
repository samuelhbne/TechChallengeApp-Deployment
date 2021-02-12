terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  region        = var.AWS_REGION
  access_key    = var.AWS_ACCESS_KEY_ID
  secret_key    = var.AWS_SECRET_ACCESS_KEY
}

resource "aws_key_pair" "key1" {
  key_name      = "${var.ENV}-key1"
  public_key    = var.PUBLIC_KEY
}
