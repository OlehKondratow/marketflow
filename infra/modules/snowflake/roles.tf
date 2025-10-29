resource "snowflake_role" "dbt_role" {
  name    = "DBT_ROLE"
  comment = "Role for dbt service"
}
