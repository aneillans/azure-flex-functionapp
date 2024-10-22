module "func" {
  source               = "../terraform"
  location             = "uksouth" # Note that not all regions are currently supported for Flex!
  function_app_name    = "fn-flex-testing"
  plan_name            = "fn-flex-plan"
  storage_account_name = "fnflexplanstr"
  resource_group_id    = azurerm_resource_group.rg.id
  resource_group_name  = azurerm_resource_group.rg.name

  auth_client_id                       = ""
  auth_require_authentication          = false
  auth_require_https                   = false
  auth_unauthentication_action         = ""
  auth_client_secret_setting_name      = ""
  auth_openid_well_known_configuration = ""
}