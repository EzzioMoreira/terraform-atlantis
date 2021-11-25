provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {
    bucket = "metal.corp-devops-test"
    key    = "infra/atlantis-terraform-.tfstate"
    region = "us-east-2"
    access_key = "AKIAXSFIMTBMQN2RFD7R"
    secret_key = "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"
  }
} 

resource "aws_s3_bucket" "b" {
  bucket = "ezzio123-my-tf-bucket"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}