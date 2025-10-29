variable "project_name" {
  default = "marketflow"
}

variable "location" {
  default = "westeurope"
}

variable "snowflake_user" {}
variable "snowflake_password" {
  sensitive = true
}
