# ⚠️ Common Issues & Troubleshooting

## ❌ KMS AccessDeniedException

`User is not authorized to perform: kms:GetKeyPolicy`

Fix: Ensure the IAM user or role has permissions for kms:GetKeyPolicy. The KMS key policy must also include the IAM user's ARN explicitly.

## ❌ MalformedPolicyDocumentException

` The new key policy will not allow you to update the key policy in the future.`

Fix: Always include "Principal": { "AWS": "arn:aws:iam::<account-id>:root" } in your KMS key policy to avoid locking yourself out.

## ❌ Terraform Identity Mismatch

`Unexpected Identity Change`

Fix: Happens when Terraform can't get key policy due to lack of permissions. Temporarily remove the aws_kms_key_policy block if needed.

## ❌ Destroy Fails Due to KMS Permissions

Fix: Either:

- Grant temporary admin access to the IAM user

- Use root user with full KMS permissions

- Wait for the key to auto-delete (if scheduled)
- Submit and AWS support ticker **(GOTCHA!!)**

## 💸 Costs & Free Tier Info

- S3: Free for first 5 GB under free tier

- DynamoDB: Free for first 25 GB storage and 200 million requests/month

- KMS:

  - First 20,000 requests per month: Free

  - After: $0.03 per 10,000 requests

  - Key creation is free; monthly key storage costs apply only if enabled and used

## 📚 Learnings

- Misconfigured KMS key policies can lock out users

- KMS deletion must be scheduled (7–30 days)

- Terraform errors often stem from missing AWS permissions

- It's better to keep your IAM user permissions minimal and use proper key policies instead

## 📂 archive/broken_attempt.tf

This file includes code blocks that failed for one reason or another — either due to policy misconfiguration, ordering issues, or lacking IAM permissions. Use this as a reference to avoid similar mistakes.
