provider "aws" {
  region  = "us-east-2"
  version = "= 3.0"
}

terraform {
  backend "s3" {
    bucket = "metal.corp-devops-test"
    key    = "infra/atlantis-terraform-.tfstate"
    region = "us-east-2"
    role_arn = "arn:aws:iam::520044189785:policy/atlantis-terraform"
  }
} 