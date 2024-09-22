# root settings
remote_state {
  backend = "s3"

  generate = {
    path      = "_backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config  = {
    # Default versioning setting is enabled.
    bucket               = "terragrunt-${local.env}-${local.name}-terraform-tfstate-s3-bucket"
    key                  = "${path_relative_to_include()}/terraform.tfstate"
    region               = "${local.region}"
    encrypt              = true
    bucket_sse_algorithm = "AES256"

    s3_bucket_tags = {
      "Environments"        = "${path_relative_to_include()}"
      "ServiceName"         = "${local.name}"
      "CreatedByTerragrunt" = "true"
    }
  }
}

generate "provider" {
  path      = "_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
    provider "aws" {
      region = "${local.region}"
      default_tags {
        tags = {
          Environment        = "${local.env}"
          ServiceName        = "${local.name}"
          ManagedByTerraform = true
        }
      }
    }
  EOF
}

generate "version" {
  path      = "_terraform.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
    terraform {
    required_version = "1.9.0"
    required_providers {
      aws = {
        version = "5.59.0"
        source  = "hashicorp/aws"
      }
    }
  }
  EOF
}

locals {
  env_vars    = yamldecode(file(find_in_parent_folders("env_vars.yaml")))
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))

  env    = local.env_vars.env
  region = local.common_vars.region
  name   = local.common_vars.name
}
