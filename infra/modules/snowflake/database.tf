resource "snowflake_database" "dbt_db" {
  name    = "DBT_DB"
  comment = "Data warehouse for dbt and analytics"
}
