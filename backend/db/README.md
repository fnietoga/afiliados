# Gestión de Migraciones de Base de Datos con Flyway

Este directorio (`backend/db/`) contiene la configuración y los scripts de migración SQL para la base de datos de la aplicación Afiliados, gestionados con Flyway.

## Prerrequisitos

1.  **Instalar Flyway CLI**: 
    *   Descarga la herramienta de línea de comandos de Flyway desde [flywaydb.org](https://flywaydb.org/documentation/usage/commandline#download-and-installation).
    *   Descomprime el archivo descargado en una ubicación de tu sistema.
    *   Añade el directorio donde descomprimiste Flyway a la variable de entorno `PATH` de tu sistema para poder ejecutar el comando `flyway` desde cualquier ubicación.

2.  **Configurar la Conexión a la Base de Datos**:
    *   Edita el archivo `flyway.conf` que se encuentra en este mismo directorio (`backend/db/`).
    *   Completa los siguientes campos con los detalles de tu Azure SQL Database (estos valores los obtendrás después de desplegar la infraestructura con Terraform o si ya tienes una base de datos existente):
        *   `flyway.url`: La cadena de conexión JDBC para tu Azure SQL Database. Ejemplo:
            `jdbc:sqlserver://<tu-servidor>.database.windows.net:1433;databaseName=<tu-base-de-datos>;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;`
        *   `flyway.user`: El nombre de usuario para acceder a la base de datos (ej. el `sql_admin_login` que configuraste en Terraform).
        *   `flyway.password`: La contraseña para el usuario de la base de datos.
            **¡PRECAUCIÓN DE SEGURIDAD!** Para entornos de producción, no guardes contraseñas en texto plano directamente en `flyway.conf`. Considera usar variables de entorno. Flyway permite esto, por ejemplo: `flyway.password=${env.FLYWAY_DB_PASSWORD}`. Luego, deberás definir la variable de entorno `FLYWAY_DB_PASSWORD` en el sistema donde ejecutes Flyway.

## Scripts de Migración

*   Los scripts de migración SQL se encuentran en el subdirectorio `migration/`.
*   Deben seguir la convención de nombres de Flyway: `V<VERSION>__<DESCRIPCION>.sql` (ej. `V1__Create_Afiliados_Table.sql`, `V2__Add_Email_Index.sql`).
*   Flyway ejecuta estos scripts en orden para aplicar los cambios al esquema de la base de datos.

## Comandos Útiles de Flyway

Ejecuta los siguientes comandos desde este directorio (`backend/db/`) en tu terminal:

1.  **Información (`info`)**:
    Muestra el estado de todas las migraciones (aplicadas, pendientes, etc.). Es útil para ver qué se ha ejecutado y qué está por ejecutarse.
    ```powershell
    flyway info
    ```

2.  **Migrar (`migrate`)**:
    Aplica todas las migraciones pendientes a la base de datos. Esto actualizará el esquema de tu base de datos al estado más reciente definido por los scripts en `migration/`.
    ```powershell
    flyway migrate
    ```

3.  **Validar (`validate`)**:
    Compara las migraciones aplicadas (registradas en la tabla `flyway_schema_history` de tu base de datos) con los scripts de migración locales. Ayuda a detectar inconsistencias.
    ```powershell
    flyway validate
    ```

4.  **Limpiar (`clean`)**:
    **¡PRECAUCIÓN!** Este comando eliminará TODOS los objetos (tablas, vistas, etc.) en los esquemas configurados en `flyway.conf` (usualmente el esquema `dbo` para SQL Server si no se especifica otro). También elimina la tabla `flyway_schema_history`. **SOLO ÚSALO EN ENTORNOS DE DESARROLLO O PRUEBAS Y SI SABES LO QUE ESTÁS HACIENDO.**
    ```powershell
    flyway clean
    ```

5.  **Reparar (`repair`)**:
    Repara la tabla `flyway_schema_history` en caso de problemas con migraciones fallidas que hayan dejado la tabla de metadatos en un estado inconsistente.
    ```powershell
    flyway repair
    ```

## Flujo de Trabajo Típico

1.  Crea un nuevo archivo SQL en `migration/` con los cambios de esquema deseados (ej. `V2__Add_New_Column.sql`).
2.  Ejecuta `flyway migrate` para aplicar los cambios a tu base de datos de desarrollo.
3.  Prueba tu aplicación con los cambios.
4.  Una vez validado, estos scripts se aplicarán en otros entornos (staging, producción) como parte de tu proceso de despliegue.
