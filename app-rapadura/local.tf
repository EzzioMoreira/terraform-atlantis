locals {
  context = {
    default = {
      buckets_name = {}
    }

    dev = {
      buckets_name = {
        bucket1 = {
          bucket_name = "metal-corp-12345"
        }
      }
    }

    stg = {
      buckets_name = {}
    }

    prd = {
      buckets_name = {}
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
