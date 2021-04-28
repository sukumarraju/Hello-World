# DB - SQL Server

resource "azurerm_sql_server" "WebApp_SQL_Server" {
  name                         = "webappqlserver"
  resource_group_name          = azurerm_resource_group.WebAppGrp_Name.name
  location                     = azurerm_resource_group.WebAppGrp_Name.location
  version                      = "12.0"
  administrator_login          = var.sql_administrator_login
  administrator_login_password = var.sql_administrator_login_password

  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.WebApp_Storage_Account_Name.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.WebApp_Storage_Account_Name.primary_access_key
    storage_account_access_key_is_secondary = true
    retention_in_days                       = 6
  }

  tags = {
    environment = "production"
  }
}

#SQL Server Auditing Storage Account
resource "azurerm_storage_account" "WebApp_Storage_Account" {
  name                     = "webappsa"
  resource_group_name      = azurerm_resource_group.WebAppGrp_Name.name
  location                 = azurerm_resource_group.WebAppGrp_Name.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

#Azure SQL Database (Managed Instance)
resource "azurerm_sql_database" "WebApp-sql-database" {
  name                = "webappsqldb"
  resource_group_name = azurerm_resource_group.WebAppGrp_Name.name
  location            = azurerm_resource_group.WebAppGrp_Name.location
  server_name         = azurerm_sql_server.WebApp_SQL_Server_Name.name

  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.WebApp_Storage_Account_Name.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.WebApp_Storage_Account_Name.primary_access_key
    storage_account_access_key_is_secondary = true
    retention_in_days                       = 6
  }


  tags = {
    environment = "production"
  }
}