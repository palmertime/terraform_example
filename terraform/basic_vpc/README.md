# basic_vpc

This code create a basic VPC with connectivity to the internet

# Deploying

Steps to deploy this Terraform config

## Environment Variables

These Environment variables should be set before executing the commands below.

**TF_WORKSPACE** : The workspace to use. EXAMPLE `dev`

**TF_aws_account** : The AWS account that will be used to deploy in.

**TF_aws_region** : The AWS region to deploy in.

**AWS_ACCESS_KEY_ID** : The AWS access key ID of the user with permissions to deploy into the AWS account.

**AWS_SECRET_ACCESS_KEY** : The AWS secret access key for the access key ID specified above.

**AWS_SESSION_TOKEN** : The AWS session token created for the above credentials.

## Parameters

These parameters should be replaces in the example commands below.

**S3_BUCKET_NAME** : The name of the S3 bucket to use as a remote backend. EXAMPLE `terraform-state`

**DYNAMODB_NAME** : The name of the DynamoDB table use for locking of State. EXAMPLE `terraform-state`

**AWS_REGION** : AWS region the State and DynamoDB are located. EXAMPLE `us-west-2`

**KEY_NAME** : The name used to create the state file. EXAMPLE `terraform.tfstate`

**PREFIX_NAME** : The path used to store the state file. EXAMPLE `environment`

**WORKSPACE** : The terraform workspace used for deployment

## Commands

Initialize Terraform backend

    terraform init --backend-config="encryption=true" \
    --backend-config="bucket=<S3_BUCKET_NAME>" \
    --backend-config="dynamodb_table=<DYNAMODB_NAME>" \
    --backend-config="region=<AWS_REGION>" \
    --backend-config="key=<KEY_NAME>" \
    --backend-config="workspace_key_prefix=<PREFIX_NAME>" \
    --input=true

Validate Terraform code

    terraform validate

Plan Terraform changes

    terraform plan -out=tf_plan

Apply Terraform changes

    terraform apply tf_plan

Delete Terraform changes

    terraform destroy

Delete Terraform Workspace

    env TF_WORKSPACE=default terraform workspace delete <WORKSPACE>
