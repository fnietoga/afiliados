# Diseño de Arquitectura de la Aplicación

## 1. Propuesta de Solución y Arquitectura Tecnológica

Para construir una aplicación robusta, escalable y moderna, se propone la siguiente pila tecnológica y arquitectura:

*   **Backend**: **ASP.NET Core Web API (.NET 9.0)**
    *   **Lenguaje**: C#
    *   **Framework**: ASP.NET Core
    *   **Por qué**: Alto rendimiento, multiplataforma, excelente integración con Azure, amplio ecosistema y herramientas de desarrollo maduras. Ideal para construir APIs RESTful seguras y eficientes.
*   **Frontend**: **React (con TypeScript)**
    *   **Lenguaje**: TypeScript/JavaScript
    *   **Librería**: React
    *   **Por qué**: Popular, componentizado, gran comunidad, ideal para Single Page Applications (SPAs) interactivas y dinámicas. TypeScript añade tipado estático para mayor robustez.
*   **Base de Datos**: **Azure SQL Database**
    *   **Tipo**: Base de datos relacional PaaS (Platform as a Service).
    *   **Por qué**: Totalmente gestionada, escalable, segura, con copias de seguridad automáticas y alta disponibilidad. Perfecta para datos estructurados como la información de contacto.

**Arquitectura de la Aplicación:**

La aplicación seguirá una arquitectura de N-capas, comúnmente desacoplada:

1.  **Capa de Presentación (Frontend - React)**:
    *   Interfaz de usuario web para que los administradores gestionen la información de los afiliados (CRUD: Crear, Leer, Actualizar, Eliminar).
    *   Componentes reutilizables para formularios, tablas de datos y navegación.
    *   Comunicación con el Backend API mediante peticiones HTTP (RESTful).
    *   Se puede alojar en Azure App Service o Azure Static Web Apps.

2.  **Capa de Lógica de Negocio y API (Backend - ASP.NET Core Web API)**:
    *   Endpoints RESTful para todas las operaciones sobre los afiliados (ej: `GET /api/afiliados`, `POST /api/afiliados`, `PUT /api/afiliados/{id}`, `DELETE /api/afiliados/{id}`).
    *   Validación de datos.
    *   Lógica de negocio (ej: reglas específicas para afiliaciones, NNGG, etc.).
    *   Autenticación y autorización (se podría integrar con Azure AD para los usuarios administradores).
    *   Interacción con la capa de acceso a datos.
    *   Alojada en Azure App Service.

3.  **Capa de Acceso a Datos (Entity Framework Core)**:
    *   Utilizaremos Entity Framework Core como ORM (Object-Relational Mapper) para interactuar con Azure SQL Database desde el backend .NET.
    *   Definición de modelos de datos que se mapean a las tablas de la base de datos.

4.  **Capa de Persistencia (Base de Datos - Azure SQL Database)**:
    *   Almacenará la información de los afiliados.

## 2. Modelo de Datos del Afiliado

La información a gestionar para cada afiliado sería:

*   `AfiliadoId` (int, Primary Key, Identity)
*   `DNI` (string, unique, max length: 20)
*   `Nombre` (string, max length: 100)
*   `Apellido` (string, max length: 100)
*   `Telefonos` (string, podría ser una lista de strings o una tabla relacionada si se necesitan múltiples teléfonos estructurados. Para simplificar inicialmente, un campo de texto o JSON.)
*   `Email` (string, unique, max length: 255)
*   `NumeroAfiliado` (string, unique, max length: 50)
*   `NNGG` (bool - Nuevas Generaciones)
*   `FechaAfiliacion` (date)
*   `AltaWeb` (bool - Indica si el alta fue a través de la web)
*   `Sexo` (string, max length: 20 - ej: "Masculino", "Femenino", "Otro")
*   `Nacionalidad` (string, max length: 100)
*   `PaisOrigen` (string, max length: 100)
*   `FechaCreacion` (datetime, default: GETUTCDATE())
*   `FechaModificacion` (datetime, default: GETUTCDATE(), se actualiza en cada cambio)
