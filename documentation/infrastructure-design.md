# Diseño de Infraestructura en Azure

A continuación, un diseño de la infraestructura en Azure para alojar esta aplicación:

1.  **Grupo de Recursos**:
    *   Un contenedor lógico para todos los recursos de Azure relacionados con este proyecto, facilitando la gestión y la facturación.

2.  **Compute**:
    *   **Azure App Service**:
        *   Un App Service Plan (ej: Standard tier) para alojar la API Backend de ASP.NET Core. Se puede elegir entre Windows o Linux (Linux suele ser más costo-efectivo).
        *   Otro App Service (o el mismo si se configura adecuadamente) para alojar la aplicación Frontend de React, o preferiblemente:
    *   **Azure Static Web Apps (Alternativa para Frontend)**:
        *   Servicio optimizado para aplicaciones web estáticas (como React) con integración nativa para CI/CD desde GitHub/Azure DevOps y APIs serverless opcionales (Azure Functions). Puede conectarse a la API de App Service.

3.  **Base de Datos**:
    *   **Azure SQL Database**:
        *   Nivel de servicio Serverless o Provisionado (ej: S0, S1) según la carga esperada. Serverless es ideal para cargas variables.
        *   Configuración de reglas de firewall y Private Endpoints para acceso seguro.

4.  **Redes**:
    *   **Azure Virtual Network (VNet)**: Para crear una red privada en Azure.
    *   **Azure Application Gateway con Web Application Firewall (WAF)**:
        *   Punto de entrada para todo el tráfico HTTP/S.
        *   Balanceo de carga.
        *   Descarga SSL.
        *   Protección WAF contra vulnerabilidades web comunes (OWASP Top 10).
    *   **Private Endpoints**: Para que Azure App Service y Azure SQL Database se comuniquen dentro de la VNet sin exponerse a la red pública de Internet.

5.  **Identidad y Seguridad**:
    *   **Azure Active Directory (Azure AD)**:
        *   Para autenticar a los usuarios administradores que gestionarán los datos de los afiliados.
        *   Se puede usar para proteger el acceso a la API.
    *   **Azure Key Vault**:
        *   Para almacenar de forma segura secretos de la aplicación como cadenas de conexión a la base de datos, claves de API, etc.
        *   Las aplicaciones (App Service) pueden acceder a Key Vault usando Managed Identities.

6.  **Monitorización y Logging**:
    *   **Azure Monitor**:
        *   **Application Insights**: Para monitorizar el rendimiento de la API y el frontend, detectar problemas, y analizar el uso.
        *   **Log Analytics Workspace**: Para centralizar logs de App Service, Application Gateway, etc.
        *   **Alertas**: Configurar alertas para condiciones críticas (errores, alta utilización de CPU, etc.).

7.  **DevOps (CI/CD)**:
    *   **Azure DevOps o GitHub Actions**:
        *   Repositorio de código fuente (Azure Repos o GitHub).
        *   Pipelines de Integración Continua (CI) para construir y probar la aplicación automáticamente.
        *   Pipelines de Despliegue Continuo (CD) para desplegar automáticamente las nuevas versiones a Azure App Service / Static Web Apps.

8.  **Almacenamiento (Opcional)**:
    *   **Azure Blob Storage**: Si se necesita almacenar archivos estáticos adicionales, imágenes de perfil de afiliados (si se añade esa funcionalidad), o backups.
