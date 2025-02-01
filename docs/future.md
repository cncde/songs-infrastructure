# Songs Infrastructure

This repository contains all configuration for the infrastructure of the songs
application. It is based on OpenTofu and all changes are applied automatically
using GitHub Actions after a change is being merged to the `main` branch.

## Authentication

Authentication to AWS is based on OpenID Connect as shown in [Configuring OpenID Connect in Amazon Web Services](https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services).

## Bootstrap

To kickstart the automation the following steps have to be executed manually.

1. Create a S3 bucket to store the OpenTofu state. It should have versioning
   enabled and be encrypted using a a CMK (SSE-KMS).
2. Create a role that can access this bucket. Set a bucket policy matching the
   IAM role. The role must have the following permissions enabled:
     * `s3:PutObject`
     * `s3:GetObject`
     * `s3:DeleteObject`
     * `s3:ListBucket`
3. Setup authentication as shown above
4. Run the first automation and setup the first resource. Once this is working,
   the existing S3 bucket is being imported into the OpenTofu setup and from
   then on also managed by the automation.

Following these steps, the infrastructure including the OpenTofu state S3 bucket
can be managed in a fully automated way.
