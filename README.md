# songs-infrastructure

This repository contains the definitions to manage the infrastructure of the songs application. Automation is based on
GitHub actions and a PullRequest workflow. The OpenTofu state is stored in an S3 bucket, which is manually created and
later imported to be managed alongside other resources.

## OpenTofu Structure

All the OpenTofu files are located in the `opentofu` folder. The setup is split into modules and environments, that
allows a selective rollout of the different components per stage. The modules do not contain any stage specific
information but can be configured via variables. The following modules exist:

- `api` contains all components to deploy the backend, the `api`
- `frontend` contains all components to deploy the `frontend` application
- `github-actions` contains all IAM roles for Github Actions
- `state` contains basic resources to manage the OpenTofu state

The `environments` folder contains the stage specific configuration files for the modules (e.g. information about the
vpc, subnets, etc.). The modules are included in the respective `main.tf`.

## Initial setup

Two things are necessary to enable automation: the state of OpenTofu needs to be stored centrally. This is done using an
S3 bucket as a backend. The second part is to create an IAM role that the GitHub action can assume to manage the
resources.

### OpenTofu state bucket

For the initial setup of the state S3 bucket follow these steps:

1. Change to `opentofu/modules/state`, run `tofu init` and `tofu plan -out=tfplan` to verify the resources to be
   created.
2. Use `tofu apply "tfplan"` create the S3 bucket to store the state.
3. The generated resource name is printed on the screen.
4. Add these to the backend configuration to the `main.tf` files in the `environments/dev`, `environments/test`, and
   `environments/prod` directories:

   ```hcl
   terraform {
      backend "s3" {
         bucket         = "<state_bucket_name>"
      }
   }
   ```

5. Replace `<state_bucket_name>` with the appropriate values from the outputs of the `opentofu/modules/state/*.tf`
   files.
6. Run the `tofu init` command in each `environments` subdirectory to initialize the backend configuration.
7. Then run the `import.sh` script in the `environments` folder to import the initial resources into the state bucket
   and enable automated management through the workflows.
8. Remove the `.terraform.lock.hcl` file.

### Github Actions Permissions

Deployment of the `github-action` module is not automated and must be done manually. This is done as a security measure.

1. Navigate into the `opentofu/modules/github-actions` module folder and create a new file (e.g.
   `iam-infrastructure-demo.tf`)

2. Make your changes (e.g. add a new IAM role).

Before actually applying changes, you should create a PR and get an approval, afterwards you can apply the changes by:

1. Navigate into the `dev` environment folder (`opentofu/environments/dev/github-actions`)

1. Run `tofu init` to download the required providers inside the directory (only required once)

1. Run `tofu plan -out=tfplan` to show what would be changed and run `tofu apply "tfplan"`.

Repeat those steps for all stages.

## Developing

### Getting started

1. Please install OpenTofu using one of the official installation methods from their
   [webpage](https://opentofu.org/docs/intro/install/). For Windows the usage of the binary is recommended as it does
   not require any special permissions.

2. Configure access to your AWS account by setting the environment variables `AWS_ACCESS_KEY_ID`,
   `AWS_SECRET_ACCESS_KEY` and `AWS_SESSION_TOKEN` from the AWS console (or use `aws configure` / `aws configure sso`).

### Changing a module

1. Navigate into the matching module folder:

   - e.g. `opentofu/modules/frontend` to edit the frontend infrastructure resources

2. Make your changes (e.g. add a new resource). Please check the
   [official provider documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) to get an idea
   of the available configuration options.

3. Navigate into the `dev` environment folder (`opentofu/environments/dev/infrastructure`)

4. Run `tofu init` to download the required providers inside the directory (only required once)

5. Run `tofu plan` to show what would be changed, please do NOT run `tofu apply` locally as this will be done by the
   pipeline after merging to `main`.

6. If needed: Change the permissions of the Github Actions pipeline, please see
   [Github Actions Permissions](#github-actions-permissions)

### Changing an environment

1. Navigate into the matching environment folder:

   - e.g. `opentofu/environments/dev/infrastructure` to edit the infrastructure configuration
   - e.g. `opentofu/environments/dev/github-actions` to edit the github-actions configuration

2. Run `tofu init` to download the required providers inside the directory (only required once)

3. Make your changes (e.g. change the configured subnet)

4. Run `tofu plan` to show what would be changed, please do NOT run `tofu apply` locally as this will be done by the
   pipeline after merging to `main`.

### Adding a new module

1. Create a new folder under `opentofu/modules`, e.g. `demo`

2. Create the file structure. OpenTofu does not require any special filenames but we use the following pattern for all
   modules:

   - `data.tf` that contain all data entries
   - `vars.tf` that contain all vars entries to configure the module later
   - `<resource>.tf` (e.g. `bucket.tf`) that contains all resources related to an s3 bucket
   - `outputs.tf` for all outputs

3. Create your resources. Please check the
   [official provider documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) to get an idea
   of the available configuration options.

4. Navigate into the `dev` environment folder (`opentofu/environments/dev/infrastructure`)

5. Run `tofu init` to download the required providers inside the directory (only required once)

6. Add your import statement to the new module:

   ```hcl
   module "demo" {
     source = "../../../modules/demo"

     # your variables here
     my_var_1 = "demo-value"
   }
   ```

7. Run `tofu plan` to show what would be changed, please do NOT run `tofu apply` locally as this will be done by the
   pipeline after merging to `main`.

8. If needed: Change the permissions of the Github Actions pipeline, please see
   [Github Actions Permissions](#github-actions-permissions)

### Formatting

The pipeline checks that your files are formatted correctly. It will fail if the files are not properly formatted. You
can use `tofu fmt -recursive` in the `opentofu` directory to automatically format all files correctly.
