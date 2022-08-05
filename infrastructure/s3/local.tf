locals {
  environment = {
    default = {
      buckets = {}
    }

    dev = {
      buckets = {
        bucket1 = {
          bucket_name = "app-metal-corp-${terraform.workspace}"
        }
      }
    }

    stg = {
      buckets = {
        bucket1 = {
          bucket_name = "metal-corp-${terraform.workspace}"
        }
      }
    }

    prd = {
      buckets = {
        bucket1 = {
          bucket_name = "metal-corp-${terraform.workspace}"
        }
        bucket2 = {
          bucket_name = "metal-web-site-estatico"
        }
      }
    }
  }

  region   = "us-east-1"
  team     = "DevOps-CE"
  env      = terraform.workspace
  project  = "Metal.corp"

  tags = {
    Env            = local.env
    Team           = local.team
    System         = "S3"
    SubSystem      = local.project
    CreationOrigin = "terraform"
  }
}
