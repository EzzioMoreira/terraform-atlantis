terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {
    bucket = "atlantis-terraform-lab"
    key    = "atlantis-terraform-.tfstate"
    region = "us-west-2"
    shared_credentials_file = "/home/atlantis/.aws/credentials"
  }
} 

resource "aws_s3_bucket" "b" {
  bucket = "ezzio123-my-tf123"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}