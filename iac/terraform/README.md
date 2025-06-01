# Despliegue de Infraestructura con Terraform

Este directorio contiene los scripts de Terraform para definir y desplegar la infraestructura de la aplicación Afiliados en Azure.

## Prerrequisitos

1.  **Instalar Terraform CLI**: Descarga e instala Terraform desde [terraform.io](https://www.terraform.io/downloads.html).
2.  **Azure CLI**: Asegúrate de tener Azure CLI instalado y configurado. Inicia sesión con `az login`.
3.  **Configurar Variables de Terraform**:
    *   Revisa y ajusta los valores por defecto en `variables.tf` según tus necesidades (nombres únicos globales para recursos, región, etc.).
    *   Para variables sensibles como `sql_admin_password`, crea un archivo llamado `terraform.tfvars` (o `personal.auto.tfvars`) en este directorio (`iac/terraform/`) y define ahí la variable. Este archivo está ignorado por Git gracias al `.gitignore` en este mismo directorio.
        
        **Ejemplo de `terraform.tfvars`**:
        ```terraform
        sql_admin_password = "TuContraseñaSuperSegura123!"
        
        # Asegúrate de que estos nombres sean globalmente únicos si los por defecto no lo son:
        # backend_app_service_name       = "app-afiliados-api-tualiasunico"
        # frontend_static_web_app_name = "stapp-afiliados-frontend-tualiasunico"
        # sql_server_name                = "sql-afiliados-server-tualiasunico"
        # key_vault_name                 = "kv-afiliados-secrets-tualiasunico"
        ```

## Comandos de Terraform

Ejecuta los siguientes comandos desde este directorio (`iac/terraform/`):

1.  **Inicializar Terraform**:
    Descarga los proveedores necesarios y prepara el entorno de Terraform.
    ```powershell
    terraform init
    ```

2.  **Validar la Configuración** (Opcional):
    Comprueba la sintaxis de tus archivos de Terraform.
    ```powershell
    terraform validate
    ```

3.  **Crear un Plan de Ejecución**:
    Muestra los cambios que Terraform realizará en tu infraestructura sin aplicarlos.
    ```powershell
    terraform plan -out=tfplan
    ```

4.  **Aplicar el Plan**:
    Crea o actualiza la infraestructura en Azure según el plan generado.
    ```powershell
    terraform apply "tfplan"
    ```
    Alternativamente, puedes aplicar directamente (Terraform te pedirá confirmación):
    ```powershell
    terraform apply
    ```

5.  **Ver Salidas** (Opcional):
    Muestra los valores de salida definidos en `outputs.tf` (ej. URLs, nombres de recursos).
    ```powershell
    terraform output
    ```

6.  **Destruir la Infraestructura**:
    **¡PRECAUCIÓN!** Este comando eliminará todos los recursos gestionados por Terraform en Azure según la configuración actual. Úsalo con cuidado.
    ```powershell
    terraform destroy
    ```

## Notas Importantes

*   **Nombres Únicos Globales**: Varios recursos de Azure (App Services, SQL Server, Key Vault, Static Web Apps) requieren nombres únicos globalmente. Asegúrate de ajustar los valores por defecto en `variables.tf` o en tu archivo `.tfvars` para evitar conflictos.
*   **Estado de Terraform**: Terraform guarda el estado de tu infraestructura en un archivo local `terraform.tfstate`. Para colaboración en equipo o entornos de producción, es altamente recomendable configurar un [backend remoto para el estado](https://www.terraform.io/language/state/backends) (ej. Azure Blob Storage).
*   **Key Vault y Secretos**: Los scripts crean un Azure Key Vault. La intención es almacenar secretos como la cadena de conexión de la base de datos en Key Vault y que tus aplicaciones (App Service) accedan a ellos mediante Managed Identities. El archivo `main.tf` incluye un ejemplo comentado de cómo crear un secreto; deberás adaptarlo y habilitar las políticas de acceso necesarias para tus aplicaciones.
*   **Static Web Apps CI/CD**: La creación de la Static Web App mediante Terraform es básica. La configuración del repositorio de código fuente para el despliegue continuo (CI/CD) generalmente se completa a través del portal de Azure o mediante pipelines de Azure DevOps/GitHub Actions después de que el recurso Static Web App es creado por Terraform.
