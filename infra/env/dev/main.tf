module "azure_infra" {
  source       = "../../modules/azure"
  project_name = var.project_name
  location     = var.location
}

module "snowflake_dwh" {
  source             = "../../modules/snowflake"
  snowflake_user     = var.snowflake_user
  snowflake_password = var.snowflake_password
  depends_on         = [module.azure_infra]
}
