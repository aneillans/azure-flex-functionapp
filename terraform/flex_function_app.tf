locals {
  deploymentContainer = "${azurerm_storage_account.storage_account.primary_blob_endpoint}deploymentpackage"
}

resource "azapi_resource" "linux_flex_function_app" {
  type                      = "Microsoft.Web/sites@2023-12-01"
  schema_validation_enabled = false
  location                  = var.location
  name                      = var.function_app_name
  parent_id                 = var.resource_group_id
  body = jsonencode({
    kind = "functionapp,linux",
    identity = {
      type : "SystemAssigned"
    }
    properties = {
      serverFarmId = azapi_resource.server_farm_plan[0].id,
      functionAppConfig = {
        deployment = {
          storage = {
            type  = "blobContainer",
            value = local.deploymentContainer,
            authentication = {
              type = "SystemAssignedIdentity"
            }
          }
        },
        scaleAndConcurrency = {
          maximumInstanceCount = var.max_instance_count,
          instanceMemoryMB     = var.instance_memory
        },
        runtime = {
          name    = var.runtime,
          version = var.runtime_version
        }
      },
      siteConfig = {
        appSettings = [
          {
            name  = "AzureWebJobsStorage__accountName",
            value = azurerm_storage_account.storage_account.name
          }
        ]
      }
    }
  })
  depends_on = [azapi_resource.server_farm_plan, azurerm_storage_account.storage_account]
}