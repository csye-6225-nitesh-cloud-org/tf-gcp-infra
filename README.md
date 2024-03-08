# Terraform and GCP Infrastructure Guide 📚

## Terraform Script to Provision Infrastructure 🚀

This guide provides an overview and useful commands for using Terraform to manage infrastructure in Google Cloud Platform (GCP).

### Terraform Useful Commands 🛠️

To manage your Terraform infrastructure, use the following commands:

- Initialize Terraform directory:
  ```
  terraform init
  ```

- Validate the Terraform files:
  ```
  terraform validate
  ```

- Create an execution plan:
  ```
  terraform plan
  ```

- Apply the changes required to reach the desired state of the configuration:
  ```
  terraform apply
  ```

### Required `.tfvar` Variables 📝

For the Terraform scripts to work, ensure you have a `.tfvar` file.

For reference, use `example.tfvars` to create your own `tfvars` file.

### Using Workspace for Isolated States 🌐

Workspaces allow you to manage different states for your infrastructure, useful for managing different environments (e.g., development, staging, production).

1. **Create a New Workspace:**
   ```shell
   terraform workspace new <workspace_name>
   ```

2. **Apply Configuration for a Workspace:**
   ```shell
   terraform apply -var-file="<filename>"
   ```

3. **Workspace Management Commands:**
    - **List Workspaces:**
      ```shell
      terraform workspace list
      ```
    - **Switch Workspace:**
      ```shell
      terraform workspace select <workspace_name>
      ```
    - **Delete Workspace:**
      **Note:** This will delete the state files. Make sure to destroy resources before deleting the workspace.
      ```shell
      terraform workspace delete -force <workspace_name>
      ```

## Enabled Google Cloud Platform (GCP) APIs 🔌

Ensure the following GCP APIs are enabled for your project:

- Compute Engine API
- Service Networking API
- BigQuery API
- BigQuery Migration API
- BigQuery Storage API
- Cloud Datastore API
- Cloud Logging API
- Cloud Monitoring API
- Cloud OS Login API
- Cloud SQL
- Cloud Storage
- Cloud Storage API
- Cloud Trace API
- Google Cloud APIs
- Google Cloud Storage JSON API
- Service Management API
- Service Usage API
