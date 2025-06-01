# Afiliados - Contact Information Management

This project contains:
- **backend/Afiliados.Api**: ASP.NET Core RESTful API (.NET 9.0)
- **frontend**: React application with TypeScript

## Getting Started

### Backend
```powershell
cd backend
# To run the API
 dotnet run
```

### Frontend
```powershell
cd frontend
# To start the React app
npm start
```

---

## Description
Application for maintaining contact information of affiliates.

---

## Database Management with Flyway

This project uses Flyway to manage database schema migrations.
For detailed instructions on how to set up and use Flyway, refer to the file:
`backend/db/README.md`

SQL migration scripts are located in `backend/db/migration/`.

---

## Infrastructure Deployment with Terraform

This project uses Terraform to define and deploy infrastructure on Azure.
Terraform scripts are located in the `iac/terraform/` folder.
For detailed instructions on how to set up and use Terraform, refer to the file:
`iac/terraform/README.md`

---

## CI/CD Pipelines

This project uses GitHub Actions for continuous integration and deployment. The following workflows are available:

1. **Infrastructure Deployment (Terraform)**: Deploys Azure infrastructure when changes are pushed to the `iac/terraform/` directory.
2. **Database Migrations (Flyway)**: Applies database migrations when changes are pushed to the `backend/db/migration/` directory.
3. **Backend API (.NET)**: Builds and deploys the ASP.NET Core API when changes are pushed to the `backend/` directory.
4. **Frontend (React)**: Builds and deploys the React application when changes are pushed to the `frontend/` directory.

GitHub Actions workflow files are located in the `.github/workflows/` directory.
