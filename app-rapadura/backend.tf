terraform {
  backend "s3" {
    bucket         = "metal-corp-lab"
    key            = "app-rapadura/terraform.tfstate"
    region         = "us-east-1"
  }
}
