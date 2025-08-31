resource "azurerm_storage_account" "storage_account" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = var.storage_account_replication_type
}

resource "azurerm_storage_container" "deployment_container" {
  name                  = "deploymentpackage"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}

resource "azurerm_role_assignment" "storage_roleassignment" {
  scope                = azurerm_storage_account.storage_account.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = data.azurerm_linux_function_app.function_wrapper.identity.0.principal_id
}

# This makes it so much easier to get the info from function app; stolen from the Flex samples!
data "azurerm_linux_function_app" "function_wrapper" {
  name                = azapi_resource.linux_flex_function_app.name
  resource_group_name = var.resource_group_name
  depends_on          = [azapi_resource.linux_flex_function_app]
}