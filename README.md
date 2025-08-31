# azure-flex-functionapp

A simple module wrapper for Flex Consumption Plans for Terraform

### Example Usage

Below is an example of how to use this module in your Terraform configuration:

```hcl
module "flex_function_app" {
	source = "./terraform"

	storage_account_name                = "mystorageacct123"
	location                            = "westeurope"
	function_app_name                   = "my-flex-func-app"
	plan_name                           = "my-flex-plan"
	resource_group_name                 = "my-resource-group"
	resource_group_id                   = "/subscriptions/xxxx/resourceGroups/my-resource-group"
	auth_require_authentication         = true
	auth_unauthentication_action        = "RedirectToLoginPage"
	auth_require_https                  = true
	auth_client_id                      = "<client-id>"
	auth_client_secret_setting_name     = "<secret-setting-name>"
	auth_openid_well_known_configuration = "<openid-config-url>"
	# Add other required variables as needed
}
```

Adjust the variable values as needed for your environment. See `variables.tf` for all available options.

### Notes

Deploy with:

```sh
func azure functionapp publish <APP_NAME>
```