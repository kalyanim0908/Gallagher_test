resource "azurerm_resource_group" "rg" {
  name= var.resource_group_name
  location = var.location
}

resource "azurerm_service_plan" "asp" {
  name = "asp-${var.app_service_name}"
  resource_group_name = azurerm_resource_group.rg.name
  location = var.location
  os_type = "Linux"
  sku_name = "F1"
}

resource "azurerm_linux_web_app" "app" {
  name = var.app_service_name
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  service_plan_id = azurerm_service_plan.asp.id
  site_config {
    application_stack {
        dotnet_version = "8.0"
    
    }
  }
  app_settings = { 
    "ASPNETCORE_ENVIRONMENT" = "Production"
  }
}