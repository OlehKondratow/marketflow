resource "snowflake_warehouse" "dbt_wh" {
  name           = "DBT_WH"
  warehouse_size = "XSMALL"
  auto_suspend   = 60
  auto_resume    = true
  comment        = "Warehouse for dbt + Airflow pipelines"
}
