variable "storage_account_name" {
  description = "The name of the Azure Storage Account to be created or used."
  type        = string
}

variable "storage_account_replication_type" {
  description = "The replication type for the storage account (e.g., LRS, GRS, RAGRS)."
  type        = string
  default     = "LRS"
}

variable "location" {
  description = "The Azure region where resources will be deployed."
  type        = string
}

variable "function_app_name" {
  description = "The name of the Azure Function App."
  type        = string
}

variable "plan_name" {
  description = "The name of the App Service plan for the Function App."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the Azure Resource Group."
  type        = string
}

variable "resource_group_id" {
  description = "The resource ID of the Azure Resource Group."
  type        = string
}

variable "max_instance_count" {
  description = "The maximum number of instances for the Function App."
  type        = number
  default     = 100
}

variable "instance_memory" {
  description = "The amount of memory (in MB) allocated per instance. Currently supports 2,048 or 4,096."
  type        = number
  default     = 2048
}

variable "runtime" {
  description = "The runtime stack for the Function App (e.g., dotnet-isolated, node)."
  type        = string
  default     = "dotnet-isolated"
}

variable "runtime_version" {
  description = "The version of the runtime stack."
  type        = string
  default     = "8.0"
}

variable "app_settings" {
  description = "A list of application settings to configure for the Function App."
  type = list(object({
    name  = string
    value = any
  }))
  default = []
}

variable "cors_allowed_origins" {
  description = "List of allowed origins for CORS."
  type        = list(string)
  default     = ["*"]
}

variable "cors_support_credentials" {
  description = "Whether CORS requests can include user credentials."
  type        = bool
  default     = false
}

variable "auth_require_authentication" {
  description = "Whether authentication is required for the Function App."
  type        = bool
}

variable "auth_unauthentication_action" {
  description = "Action to take for unauthenticated requests."
  type        = string
}

variable "auth_forward_proxy_convention" {
  description = "Convention for forwarding proxy (e.g., NoProxy)."
  type        = string
  default     = "NoProxy"
}

variable "auth_require_https" {
  description = "Whether HTTPS is required for authentication."
  type        = bool
}

variable "auth_http_route_api_prefix" {
  description = "Prefix for authentication HTTP routes."
  type        = string
  default     = "/.auth"
}

variable "auth_enabled" {
  description = "Whether authentication is enabled."
  type        = bool
  default     = false
}

variable "auth_runtime_version" {
  description = "The version of the authentication runtime."
  type        = string
  default     = "~1"
}

variable "auth_client_id" {
  description = "The client ID for OpenID authentication."
  type        = string
}

variable "auth_client_secret_setting_name" {
  description = "The name of the secret setting for the OpenID client secret."
  type        = string
  sensitive   = true
}

variable "auth_openid_well_known_configuration" {
  description = "The well-known OpenID configuration URL."
  type        = string
  sensitive   = true
}

variable "auth_login_token_store_enabled" {
  description = "Whether to enable token store for login sessions."
  type        = bool
  default     = true
}

variable "auth_login_token_refresh_hours" {
  description = "Number of hours before login token refresh is required."
  type        = number
  default     = 72
}

variable "auth_login_validate_nonce" {
  description = "Whether to validate nonce during login."
  type        = bool
  default     = true
}

variable "auth_login_logout_endpoint" {
  description = "Endpoint for logout requests."
  type        = string
  default     = "/.auth/logout"
}