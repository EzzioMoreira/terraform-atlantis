terraform {
  backend "s3" {
    bucket = "lab-terraform-ezzio"
    key    = "app-rapadura/terraform.tfstate"
    region = "us-east-1"
  }
}
