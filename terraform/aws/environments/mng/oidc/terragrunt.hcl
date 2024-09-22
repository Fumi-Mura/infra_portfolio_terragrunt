# child settings
include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/oidc"
}

inputs = {
  env  = local.env
  name = local.service_name
}

locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
  env_vars    = yamldecode(file(find_in_parent_folders("env_vars.yaml")))

  env = local.env_vars.env
  service_name = local.common_vars.service_name
}
