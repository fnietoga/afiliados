terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0"
    }
  }
}

provider "azurerm" {
  features {}
  # Si estás usando Azure CLI para autenticarte, esta es la configuración más simple.
  # También puedes configurar la autenticación mediante Service Principal, Managed Identity, etc.
  # subscription_id = "TU_SUBSCRIPTION_ID" # Opcional si usas Azure CLI y tienes la suscripción correcta seleccionada
  # client_id       = "TU_CLIENT_ID"       # Para Service Principal
  # client_secret   = "TU_CLIENT_SECRET"   # Para Service Principal
  # tenant_id       = "TU_TENANT_ID"       # Para Service Principal
}
