#Image config
data "azurerm_image" "WebGoldImage_Name" {
  name                = "WebGoldImage"
  resource_group_name = "WebImageAppRg"
}
