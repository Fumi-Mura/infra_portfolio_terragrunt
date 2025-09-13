locals {
  env  = "dev"
  name = "fumis-pf"
}

module "cwlogs1" {
  source = "../../../modules/cloudwatch/log"
  env    = local.env
  name   = local.name
  prefix = "test"
  role   = "test1"
}
