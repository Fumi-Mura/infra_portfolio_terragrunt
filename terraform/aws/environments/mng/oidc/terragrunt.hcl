# child settings
include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/oidc"
}

inputs = {
  env = "mng"
  name = "my-app-production"
}

locals {
  env = "mng"
}
