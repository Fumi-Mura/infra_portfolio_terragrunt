locals {
  env  = "mng"
  name = "fumis-portfolio"
}

module "oidc" {
  source = "../../../../../../modules/oidc" # .terragurnt-cache/xxx/xxx/以下から実行される
  env    = local.env
  name   = local.name
}
