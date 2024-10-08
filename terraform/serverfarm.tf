resource "azapi_resource" "server_farm_plan" {
  count = var.app_service_plan == null ? 1 : 0

  type                      = "Microsoft.Web/serverfarms@2023-12-01"
  schema_validation_enabled = false
  location                  = var.location
  name                      = var.plan_name
  parent_id                 = var.resource_group_id
  body = jsonencode({
    kind = "functionapp",
    sku = {
      tier = "FlexConsumption",
      name = "FC1"
    },
    properties = {
      reserved = true
    }
  })
}