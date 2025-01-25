# songs-infrastructure

This repository contains the code to manage the infrastructure of the songs application. The automation is based on
GitHub Actions and a PullRequest workflow. The OpenTofu state is stored in an S3 bucket, which is created manually and
later imported to be managed alongside other resources.


## Initial setup

For the initial setup follow these steps:

1. Change to `opentofu/modules/state`, run `tofu init` and `tofu plan -out=tfplan` to verify the resources to be
   created.
2. Use `tofu apply "tfplan"` create the bucket to store the state and the DynamoDB for locking purposes.
3. The generated resource names are printed on the screen.
4. Add these to the backend configuration to the `main.tf` files in the `environments/dev`, `environments/test`, and
   `environments/prod` directories:

```hcl
terraform {
  backend "s3" {
    bucket         = "<state_bucket_name>"
    dynamodb_table = "<dynamodb_table_name>"
  }
}
```

1. Replace `<state_bucket_name>` and `<dynamodb_table_name>` with the appropriate values from the outputs of the
   `opentofu/modules/state/*.tf` files.
2. Run the `tofu init` command in each environment directory to initialize the backend configuration.
