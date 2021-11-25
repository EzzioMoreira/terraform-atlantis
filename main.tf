provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {
    bucket = "atlantis-terraform-lab"
    key    = "atlantis-terraform-.tfstate"
    region = "us-west-2"
    access_key = "AKIAXSFIMTBMQN2RFD7R"
    secret_key = "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"
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