# Note: Flex Consumption App Service plans CAN NOT be shared.
resource "azurerm_service_plan" "server_farm" {
  name                = var.plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "FC1" # FC1 is the SKU for the FlexConsumption plan
  os_type             = "Linux"
}