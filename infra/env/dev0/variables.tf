variable "location" {
  description = "Azure region"
  default     = "westeurope"
}

variable "prefix" {
  description = "Prefix for resources"
  default     = "marketflow"
}

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID"
}

variable "tenant_id" {
  type        = string
  description = "Azure tenant ID"
}

variable "project_name" {
  description = "Project name prefix used for all resources"
  type        = string
  default     = "marketflow"
}