# child settings
locals {
  env_vars    = yamldecode(file(find_in_parent_folders("env_vars.yaml")))
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))

  region = local.common_vars.region
  env    = local.env_vars.env
  name   = local.common_vars.name
}

inputs = {
  env    = local.env
  name   = local.name
  role   = "test"
  prefix = "test"
}

include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/cloudwatch/log"
}
