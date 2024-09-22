# root settings
remote_state {
  backend = "s3"

  generate = {
    path      = "_backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config  = {
    bucket  = "terragrunt-${local.env}-${local.name}-terraform-tfstate-s3-bucket"
    key     = "${path_relative_to_include()}/terraform.tfstate"
    region  = "ap-northeast-1"
    encrypt = true

    s3_bucket_tags = {
      "Environments"        = "${path_relative_to_include()}"
      "ServiceName"         = "${local.name}"
      "CreatedByTerragrunt" = "true"
    }
  }
}

locals {
  env_vars    = yamldecode(file(find_in_parent_folders("env_vars.yaml")))
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))

  env  = local.env_vars.env
  name = local.common_vars.name
}

// generate "provider" {
//   path      = "_provider.tf"
//   if_exists = "overwrite_terragrunt"
//   contents  = <<EOF
//     provider "aws" {
//       region = "${local.region_name}"
//       default_tags {
//         tags = {
//           Environment        = "${local.env}"
//           ServiceName        = "${local.name}"
//           ManagedByTerraform = true
//         }
//       }
//     }
//   EOF
// }

// generate "version" {
//   path      = "_version.tf"
//   if_exists = "overwrite_terragrunt"
//   contents  = <<EOF
//     terraform {
//     required_version = "1.9.0"
//     required_providers {
//       aws = {
//         version = "5.59.0"
//         source  = "hashicorp/aws"
//       }
//     }
//   }
//   EOF
// }
