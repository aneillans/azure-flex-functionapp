variable "storage_account_name" {
  type = string
}

variable "location" {
  type = string
}

variable "function_app_name" {
  type = string
}

variable "plan_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "resource_group_id" {
  type = string
}

variable "max_instance_count" {
  type    = number
  default = 100
}

variable "instance_memory" {
  type        = number
  default     = 2048
  description = "MB of Memory for instance; currently supports 2,048 or 4,096"
}

variable "runtime" {
  type    = string
  default = "dotnet-isolated"
}

variable "runtime_version" {
  type    = string
  default = "8.0"
}

variable "app_settings" {
  type = list(object({
    name  = string
    value = any
  }))
  default = []
}

variable "cors_allowed_origins" {
  type    = list(string)
  default = ["*"]
}

variable "cors_support_credentials" {
  type    = bool
  default = false
}

variable "auth_require_authentication" {
  type = bool
}

variable "auth_unauthentication_action" {
  type = string
}

variable "auth_forward_proxy_convention" {
  type    = string
  default = "NoProxy"
}

variable "auth_require_https" {
  type = bool
}

variable "auth_http_route_api_prefix" {
  type    = string
  default = "/.auth"
}

variable "auth_enabled" {
  type    = bool
  default = false
}

variable "auth_runtime_version" {
  type    = string
  default = "~1"
}

variable "auth_client_id" {
  type = string
}

variable "auth_client_secret_setting_name" {
  type = string
}

variable "auth_openid_well_known_configuration" {
  type = string
}

variable "auth_login_token_store_enabled" {
  type    = bool
  default = true
}

variable "auth_login_token_refresh_hours" {
  type    = number
  default = 72
}

variable "auth_login_validate_nonce" {
  type    = bool
  default = true
}

variable "auth_login_logout_endpoint" {
  type    = string
  default = "/.auth/logout"
}