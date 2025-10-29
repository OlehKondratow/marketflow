resource "snowflake_user" "dbt_user" {
  name              = "DBT_USER"
  login_name        = "dbt_user"
  password          = ""
  default_role      = snowflake_role.dbt_role.name
  default_warehouse = snowflake_warehouse.dbt_wh.name
  default_namespace = "${snowflake_database.dbt_db.name}.PUBLIC"
}
