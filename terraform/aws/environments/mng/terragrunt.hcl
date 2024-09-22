# child settings
include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules/"
}

inputs = {
  name = "my-app-production"
}
