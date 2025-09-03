# 🚀 Terraform Remote State Backend on AWS (S3 + KMS + DynamoDB)

## Overview

This project sets up a secure and versioned Terraform backend using:

- Amazon S3 for state file storage

- AWS KMS for encryption

- DynamoDB for state locking

## ⚙️ Features

- S3 bucket with versioning and encryption

- KMS key created and used to encrypt S3 objects

- DynamoDB table for Terraform state locking

- IAM access policies for controlled permissions

## 📦 Terraform Setup

Files

- main.tf: All main resource definitions

- variables.tf: Variables used (if any)

- outputs.tf: Output definitions (optional)

- archive/broken_attempts.tf: File containing failed or experimental code

## 🛠️ Prerequisites

- AWS account (even free tier)

- IAM user with proper permissions (kms:_, s3:_, dynamodb:\*)

- Terraform v1.x

## ✅ How to Use

1. Clone this repository

2. Customize bucket names in state.tf

Run:

```
terraform init
terraform apply
```

3. Uncomment the **Configure S3 bucket as remote backend** in terraform.tf
4. Run:

```
terraform apply
```
