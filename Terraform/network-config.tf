#VNet Config
resource "azurerm_virtual_network" "WebVnet_Name" {
  name                = "WebVnet"
  resource_group_name = azurerm_resource_group.WebAppGrp_Name.name
  location            = azurerm_resource_group.WebAppGrp_Name.location
  address_space       = ["10.10.0.0/16"]
}

#WFE Subnet Config
resource "azurerm_subnet" "WebAppFE_Name" {
  name                 = "WebAppFE"
  resource_group_name  = azurerm_resource_group.WebAppGrp_Name.name
  virtual_network_name = azurerm_virtual_network.WebVnet_Name.name
  address_prefixes     = ["10.10.1.0/24"]
}

#Backend Subnet Config
resource "azurerm_subnet" "WebAppBE_Name" {
  name                 = "WebAppBE"
  resource_group_name  = azurerm_resource_group.WebAppGrp_Name.name
  virtual_network_name = azurerm_virtual_network.WebVnet_Name.name
  address_prefixes     = ["10.10.2.0/24"]
}

#IP Config
resource "azurerm_public_ip" "WebAppPIP_Name" {
  name                = "WebAppPIP"
  resource_group_name = azurerm_resource_group.WebAppGrp_Name.name
  location            = azurerm_resource_group.WebAppGrp_Name.location
  allocation_method   = "Dynamic"
}

#Local variables
locals {
  backend_address_pool_name      = "${azurerm_virtual_network.WebVnet_Name.name}-beap"
  frontend_port_name             = "${azurerm_virtual_network.WebVnet_Name.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.WebVnet_Name.name}-feip"
  http_setting_name              = "${azurerm_virtual_network.WebVnet_Name.name}-be-htst"
  listener_name                  = "${azurerm_virtual_network.WebVnet_Name.name}-httplstn"
  request_routing_rule_name      = "${azurerm_virtual_network.WebVnet_Name.name}-rqrt"
  redirect_configuration_name    = "${azurerm_virtual_network.WebVnet_Name.name}-rdrcfg"
}

#Application Gateway Configuration
resource "azurerm_application_gateway" "AppGtWay_Name" {
  name                = "AppGtWay"
  resource_group_name = azurerm_resource_group.WebAppGrp_Name.name
  location            = azurerm_resource_group.WebAppGrp_Name.location

  sku {
    name     = "Standard_Small"
    tier     = "Standard"
    capacity = 2
  }

  #App Gateway
  gateway_ip_configuration {
    name      = "App-gateway-ip-configuration"
    subnet_id = azurerm_subnet.WebAppFE_Name.id
  }

#IP Config
  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.WebAppPIP_Name.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

#Backend Http config
  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

# Http Listener
  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

#Route Rule
  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
}
