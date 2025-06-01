# --- Grupo de Recursos ---
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# --- Application Insights (para monitorización) ---
resource "azurerm_application_insights" "appi" {
  name                = var.application_insights_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"
  tags                = var.tags
}

# --- App Service Plan (para el Backend API) ---
resource "azurerm_service_plan" "asp" {
  name                = var.app_service_plan_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux" # O "Windows" si prefieres
  sku_name            = "B1"    # SKU Básico, considera cambiar para producción (ej. S1, P1V2)
  tags                = var.tags
}

# --- App Service (para el Backend API) ---
resource "azurerm_linux_web_app" "backend_app" { # Cambia a azurerm_windows_web_app si os_type es Windows
  name                = var.backend_app_service_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.asp.location
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    # Configuración para .NET (ej. si usas Linux)
    # Para .NET 9, asegúrate de que el runtime esté disponible o usa contenedores.
    # application_stack {
    #   dotnet_version = "8.0" # Ajusta según el runtime de .NET que uses
    # }
    # Considera usar contenedores para mayor flexibilidad con versiones de .NET
  }

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.appi.instrumentation_key
    # Aquí añadirás la cadena de conexión a la BD desde Key Vault más adelante
    # "ConnectionStrings__DefaultConnection" = "@Microsoft.KeyVault(SecretUri=...)"
  }
  tags = var.tags
}

# --- Azure Static Web App (para el Frontend) ---
# Nota: La creación de Static Web Apps con Terraform es básica.
# La conexión al repositorio y el build/deploy se configuran usualmente
# a través del portal de Azure, Azure DevOps o GitHub Actions después de la creación inicial.
resource "azurerm_static_site" "frontend_app" {
  name                = var.frontend_static_web_app_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location # Static Web Apps son globales pero se especifica una región para la gestión
  sku_tier            = "Free" # O "Standard"
  tags                = var.tags
  # repository_url      = "URL_DE_TU_REPOSITORIO_GIT" # Opcional, para configurar CI/CD
  # branch              = "main" # Opcional
  # app_location        = "/frontend" # Opcional, ruta a tu app en el repo
  # api_location        = "" # Opcional, si tienes Azure Functions gestionadas por SWA
  # output_location     = "build" # Opcional, carpeta de salida del build del frontend
}

# --- Azure SQL Server ---
resource "azurerm_mssql_server" "sqlserver" {
  name                         = var.sql_server_name
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0" # Versión estándar de SQL Server
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password
  tags                         = var.tags

  # Considera añadir reglas de firewall aquí o gestionarlas por separado
  # azurerm_mssql_firewall_rule
}

# --- Azure SQL Database ---
resource "azurerm_mssql_database" "sqldb" {
  name           = var.sql_database_name
  server_id      = azurerm_mssql_server.sqlserver.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  sku_name       = "S0" # SKU Básico, considera cambiar para producción (ej. Serverless)
  # max_size_gb    = 2 # Para S0, el tamaño puede variar. Ajusta según el SKU.
  tags           = var.tags
}

# --- Azure Key Vault ---
resource "azurerm_key_vault" "kv" {
  name                        = var.key_vault_name
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard" # o "premium"
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false # Considera true para producción
  tags                        = var.tags

  # Política de acceso para que el usuario/SP que ejecuta Terraform pueda gestionar secretos
  # Reemplaza object_id con el ID del principal que necesita acceso (usuario, SP, grupo)
  # access_policy {
  #   tenant_id = data.azurerm_client_config.current.tenant_id
  #   object_id = data.azurerm_client_config.current.object_id # O el ID de tu Service Principal
  #   secret_permissions = [
  #     "Get", "List", "Set", "Delete"
  #   ]
  # }

  # Aquí podrías añadir políticas de acceso para que tu App Service acceda a los secretos
  # usando su Managed Identity.
}

# Data source para obtener el tenant_id y object_id del cliente actual (Azure CLI login o SP)
data "azurerm_client_config" "current" {}

# Ejemplo de cómo añadir un secreto a Key Vault (la cadena de conexión de la BD)
# La cadena de conexión real se construye con las salidas del servidor SQL.
# resource "azurerm_key_vault_secret" "db_connection_string" {
#   name         = "DefaultConnection"
#   key_vault_id = azurerm_key_vault.kv.id
#   value        = "Server=tcp:${azurerm_mssql_server.sqlserver.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.sqldb.name};User ID=${var.sql_admin_login};Password=${var.sql_admin_password};Encrypt=true;TrustServerCertificate=false;Connection Timeout=30;"
#   depends_on = [azurerm_key_vault.kv, azurerm_mssql_database.sqldb]
# }
