# Contains all the variables

variable "resourceGroupName" {
  type        = string
  description = "Resource Group Name"
}
variable "location" {
  type        = string
  description = "Location"
}
variable "subscription_id" {
  type        = string
  description = "subscription Id"
}
variable "client_id" {
  type        = string
  description = "client Id"
}
variable "client_secret" {
  type        = string
  description = "client secret"
}
variable "tenant_id" {
  type        = string
  description = "Tenant Id"
}
variable "sql_administrator_login" {
  type        = string
  description = "SQL Admin user name for DB Server"
}
variable "sql_administrator_login_password" {
  type        = string
  description = "SQL Admin password associated with the admin login"
}
variable "admin_username" {
  type        = string
  description = "VM admin user name"
}

variable "admin_password" {
  type        = string
  description = "Password must meet Azure pw requirements"
}
variable "sqlSecondary_location" {
  type        = string
  description = "SQL Server Secondary location"
}

variable "webgoldimageId" {
  type        = string
  description = "Gold Disk Image Id"
}

