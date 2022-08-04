terraform {
  backend "s3" {
    bucket = "lab-terraform-ezzio"
    key    = "s3/terraform.tfstate"
    region = "us-east-1"
  }
}
