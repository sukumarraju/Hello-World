# VM Scale Set
resource "azurerm_virtual_machine_scale_set" "WebAppVMSS_Name" {
  name                = "webappvmss"
  resource_group_name = azurerm_resource_group.WebAppGrp_Name.name
  location            = azurerm_resource_group.WebAppGrp_Name.location
  upgrade_policy_mode = "Manual"

#SKU

  sku {
    name     = "Standard_DS1_v2"
    tier     = "Standard"
    capacity = 2
  }

  storage_profile_image_reference {
    id = data.azurerm_image.WebGoldImage_Name.id
  }

  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_profile_data_disk {
    lun           = 0
    caching       = "ReadWrite"
    create_option = "Empty"
    disk_size_gb  = 10
  }

  os_profile {
    computer_name_prefix = "vmlab"
    admin_username       = var.admin_username
    admin_password       = var.admin_password
  }

#Network profile
  network_profile {
    name    = "WebAppvmssnet_Name"
    primary = true

    ip_configuration {
      name                                   = "webVMSSIPConfiguration"
      subnet_id                              = azurerm_subnet.WebAppBE_Name.id
      load_balancer_backend_address_pool_ids = [azurerm_application_gateway.AppAppGtWay_Name.backend_address_pool.0.id]
      primary                                = true
    }
  }

  tags = {
    environment = "Production"
  }
}

#Cache

resource "azurerm_redis_cache" "Web_Redis_Cache_Name" {
  name                = "web-cache-01"
  location            = azurerm_resource_group.WebAppGrp_Name.location
  resource_group_name = azurerm_resource_group.WebAppGrp_Name.name
  capacity            = 2
  family              = "C"
  sku_name            = "Standard"
  enable_non_ssl_port = false
  minimum_tls_version = "1.2"

  redis_configuration {
  }
}