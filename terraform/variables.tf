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
  type    = string
  default = "100"
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

variable "app_service_plan" {
  type = string
  default = null
  description = "Resource ID of an existing App Service Plan; if none provided, a new ASP will be created"
}