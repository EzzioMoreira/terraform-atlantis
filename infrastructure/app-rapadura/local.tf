locals {
  environment = {
    default = {
      instance_type = {}
    }

    dev = {
      instance_type = {}
    }

    stg = {
      instance_type = {
        instance_1 = {
          instance_type = "t2.micro"
          key_name      = "access.stg"
        }
      }
    }

    prd = {
      instance_type = {
        instance_1 = {
          instance_type = "t2.medium"
          key_name      = "access.prd"
        },
        instance_2 = {
          instance_type = "t2.medium"
          key_name      = "access.prd"
        }
      }
    }
  }

  region  = "us-east-1"
  team    = "DevOps-CE"
  env     = terraform.workspace
  project = "Metal.corp"

  tags = {
    Env            = local.env
    Team           = local.team
    System         = "Instancia-ec2"
    SubSystem      = local.project
    CreationOrigin = "terraform"
  }
}
