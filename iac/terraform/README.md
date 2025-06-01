# Infrastructure Deployment with Terraform

This directory contains the Terraform scripts to define and deploy the Afiliados application infrastructure on Azure.

## Prerequisites

1.  **Install Terraform CLI**: Download and install Terraform from [terraform.io](https://www.terraform.io/downloads.html).
2.  **Azure CLI**: Ensure you have Azure CLI installed and configured. Log in with `az login`.
3.  **Configure Terraform Variables**:
    *   Review and adjust the default values in `variables.tf` according to your needs (globally unique names for resources, region, etc.).
    *   For sensitive variables like `sql_admin_password`, create a file named `terraform.tfvars` (or `personal.auto.tfvars`) in this directory (`iac/terraform/`) and define the variable there. This file is ignored by Git thanks to the `.gitignore` in this same directory.

        **Example of `terraform.tfvars`**:
        ```terraform
        sql_admin_password = "YourSuperSecurePassword123!"

        # Ensure these names are globally unique if the defaults are not:
        # backend_app_service_name       = "app-afiliados-api-youruniqualias"
        # frontend_static_web_app_name = "stapp-afiliados-frontend-youruniqualias"
        # sql_server_name                = "sql-afiliados-server-youruniqualias"
        # key_vault_name                 = "kv-afiliados-secrets-youruniqualias"
        ```

## Terraform Commands

Run the following commands from this directory (`iac/terraform/`):

1.  **Initialize Terraform**:
    Downloads the necessary providers and prepares the Terraform environment.
    ```powershell
    terraform init
    ```

2.  **Validate Configuration** (Optional):
    Checks the syntax of your Terraform files.
    ```powershell
    terraform validate
    ```

3.  **Create an Execution Plan**:
    Shows the changes Terraform will make to your infrastructure without applying them.
    ```powershell
    terraform plan -out=tfplan
    ```

4.  **Apply the Plan**:
    Creates or updates the infrastructure in Azure according to the generated plan.
    ```powershell
    terraform apply "tfplan"
    ```
    Alternatively, you can apply directly (Terraform will ask for confirmation):
    ```powershell
    terraform apply
    ```

5.  **View Outputs** (Optional):
    Displays the output values defined in `outputs.tf` (e.g., URLs, resource names).
    ```powershell
    terraform output
    ```

6.  **Destroy Infrastructure**:
    **WARNING!** This command will delete all Terraform-managed resources in Azure according to the current configuration. Use with caution.
    ```powershell
    terraform destroy
    ```

## Important Notes

*   **Globally Unique Names**: Several Azure resources (App Services, SQL Server, Key Vault, Static Web Apps) require globally unique names. Ensure you adjust the default values in `variables.tf` or in your `.tfvars` file to avoid conflicts.
*   **Terraform State**: Terraform saves the state of your infrastructure in a local file `terraform.tfstate`. For team collaboration or production environments, it is highly recommended to configure a [remote backend for the state](https://www.terraform.io/language/state/backends) (e.g., Azure Blob Storage).
*   **Key Vault and Secrets**: The scripts create an Azure Key Vault. The intention is to store secrets like the database connection string in Key Vault and have your applications (App Service) access them via Managed Identities. The `main.tf` file includes a commented example of how to create a secret; you will need to adapt it and enable the necessary access policies for your applications.
*   **Static Web Apps CI/CD**: The creation of the Static Web App via Terraform is basic. The configuration of the source code repository for continuous deployment (CI/CD) is usually completed through the Azure portal or via Azure DevOps/GitHub Actions pipelines after the Static Web App resource is created by Terraform.
