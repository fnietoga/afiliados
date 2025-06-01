output "resource_group_name" {
  description = "Nombre del grupo de recursos."
  value       = azurerm_resource_group.rg.name
}

output "backend_app_service_hostname" {
  description = "Hostname del App Service del backend."
  value       = azurerm_linux_web_app.backend_app.default_hostname
}

output "frontend_static_web_app_url" {
  description = "URL de la Static Web App del frontend."
  value       = azurerm_static_site.frontend_app.default_hostname
}

output "sql_server_fqdn" {
  description = "FQDN del servidor Azure SQL."
  value       = azurerm_mssql_server.sqlserver.fully_qualified_domain_name
}

output "sql_database_name" {
  description = "Nombre de la Azure SQL Database."
  value       = azurerm_mssql_database.sqldb.name
}

output "key_vault_uri" {
  description = "URI del Azure Key Vault."
  value       = azurerm_key_vault.kv.vault_uri
}

output "application_insights_instrumentation_key" {
  description = "Clave de instrumentación de Application Insights."
  value       = azurerm_application_insights.appi.instrumentation_key
  sensitive   = true
}
