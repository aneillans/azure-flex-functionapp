output "name" {
    value = data.azurerm_linux_function_app.function_wrapper.name
}

output "id" {
    value = data.azurerm_linux_function_app.function_wrapper.id
}

output "app_service_plan_id" { 
    value = data.azurerm_linux_function_app.function_wrapper.service_plan_id
}