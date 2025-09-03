# KMS Issues & Debugging

## Issue: AccessDeniedException for `kms:GetKeyPolicy`

### Error

```bash
User is not authorized to perform: kms:GetKeyPolicy
```

Root Cause

The key policy was missing permissions for the IAM user.

Fix

Ensure the key policy includes:

```
{
  "Effect": "Allow",
  "Principal": {
    "AWS": "arn:aws:iam::<account-id>:user/terraform-user"
  },
  "Action": [
    "kms:*"
  ],
  "Resource": "*"
}
```

Always be careful with wildcard permissions. Restrict in production environments.
