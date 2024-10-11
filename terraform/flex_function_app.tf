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
      serverFarmId = azapi_resource.server_farm_plan.id,
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
      cors = {
        allowedOrigins = var.cors_allowed_origins,
        supportCredentials = var.cors_support_credentials
      },
      siteConfig = {
        appSettings = setunion([
          {
            name  = "AzureWebJobsStorage__accountName",
            value = azurerm_storage_account.storage_account.name
          }], var.app_settings)
      }
    }
  })
  depends_on = [azapi_resource.server_farm_plan, azurerm_storage_account.storage_account]
}

resource "azapi_resource" "flex_function_authsettings" {
  type                      = "Microsoft.Web/sites/config@2023-12-01"
  schema_validation_enabled = false
  location                  = var.location
  name                      = "authsettingsV2"
  parent_id                 = azapi_resource.linux_flex_function_app.id
  body = jsonencode({
    kind = "string",
    properties = {
      globalValidation = {
        redirectToProvider = "OpenIDAuth",
        requireAuthentication = var.auth_require_authentication,
        unauthentedClientAction = var.auth_unauthentication_action
      },
      httpSettings = {
        forwardProxy = {
          convention = var.auth_forward_proxy_convention
        },
        requireHttps = var.auth_require_https,
        routes = {
          apiPrefix = var.auth_http_route_api_prefix
        }
      },
      platform = {
        enabled = var.auth_enabled,
        runtimeVersion = var.auth_runtime_version
      },
      identityProviders = {
        "OpenIDAuth" = {
          enabled = "true",
          registration = {
            clientId = var.auth_client_id,
            clientCredential = {
              clientSecretSettingName = var.auth_client_secret_setting_name
            },
            openIdConnectConfiguration = {
              authorizationEndpoint = var.auth_openid_auth_endpoint,
              tokenEndpoint = var.auth_openid_token_endpoint,
              issuer = var.auth_openid_issuer,
              certificationUri = var.auth_openid_certification_uri,
              wellKnownOpenIdConfiguration = var.auth_openid_well_known_configuration
            }
          }
        }
      }
    }
  })
}