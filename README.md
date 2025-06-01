# Afiliados - Gestión de Información de Contacto

Este proyecto contiene:
- **backend/Afiliados.Api**: API RESTful en ASP.NET Core (.NET 9.0)
- **frontend**: Aplicación React con TypeScript

## Primeros pasos

### Backend
```powershell
cd backend
# Para ejecutar la API
 dotnet run
```

### Frontend
```powershell
cd frontend
# Para iniciar la app React
npm start
```

---

## Descripción
Aplicación para el mantenimiento de la información de contacto de afiliados.

---

## Gestión de Base de Datos con Flyway

Este proyecto utiliza Flyway para gestionar las migraciones del esquema de la base de datos.
Para instrucciones detalladas sobre cómo configurar y usar Flyway, consulta el archivo:
`backend/db/README.md`

Los scripts de migración SQL se encuentran en `backend/db/migration/`.

---

## Despliegue de Infraestructura con Terraform

Este proyecto utiliza Terraform para definir y desplegar la infraestructura en Azure.
Los scripts de Terraform se encuentran en la carpeta `iac/terraform/`.
Para instrucciones detalladas sobre cómo configurar y usar Terraform, consulta el archivo:
`iac/terraform/README.md`
