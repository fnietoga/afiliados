variable "resource_group_name" {
  description = "Nombre del grupo de recursos para todos los recursos."
  type        = string
  default     = "rg-afiliados-app"
}

variable "location" {
  description = "Ubicación de Azure donde se desplegarán los recursos."
  type        = string
  default     = "West Europe" # Cambia a tu región preferida
}

variable "app_service_plan_name" {
  description = "Nombre del App Service Plan para el backend."
  type        = string
  default     = "asp-afiliados-backend"
}

variable "backend_app_service_name" {
  description = "Nombre del App Service para la API backend (debe ser globalmente único)."
  type        = string
  # Asegúrate de que este nombre sea único globalmente
  default     = "app-afiliados-api-unique"
}

variable "frontend_static_web_app_name" {
  description = "Nombre de la Static Web App para el frontend (debe ser globalmente único)."
  type        = string
  # Asegúrate de que este nombre sea único globalmente
  default     = "stapp-afiliados-frontend-unique"
}

variable "sql_server_name" {
  description = "Nombre del servidor Azure SQL (debe ser globalmente único)."
  type        = string
  # Asegúrate de que este nombre sea único globalmente
  default     = "sql-afiliados-server-unique"
}

variable "sql_database_name" {
  description = "Nombre de la base de datos Azure SQL."
  type        = string
  default     = "db-afiliados"
}

variable "sql_admin_login" {
  description = "Nombre de usuario del administrador de Azure SQL Server."
  type        = string
  default     = "sqladminuser"
}

variable "sql_admin_password" {
  description = "Contraseña para el administrador de Azure SQL Server. ¡Debe ser compleja!"
  type        = string
  sensitive   = true
  # No pongas la contraseña aquí directamente para producción.
  # Usa un archivo terraform.tfvars (gitignored) o variables de entorno.
}

variable "key_vault_name" {
  description = "Nombre del Azure Key Vault (debe ser globalmente único)."
  type        = string
  # Asegúrate de que este nombre sea único globalmente
  default     = "kv-afiliados-secrets-unique"
}

variable "application_insights_name" {
  description = "Nombre del recurso Application Insights."
  type        = string
  default     = "appi-afiliados-app"
}

variable "tags" {
  description = "Etiquetas comunes para aplicar a los recursos."
  type        = map(string)
  default = {
    Proyecto    = "AfiliadosApp"
    Entorno     = "Desarrollo"
    GestionadoPor = "Terraform"
  }
}
