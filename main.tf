provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {
    bucket = "metal.corp-devops-test"
    key    = "infra/atlantis-terraform-.tfstate"
    region = "us-east-2"
    role_arn = "arn:aws:iam::520044189785:role/Atantis-role-terraform"
  }
} 

resource "aws_s3_bucket" "b" {
  bucket = "ezzio-moreira-my-tf-test-bucket"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}