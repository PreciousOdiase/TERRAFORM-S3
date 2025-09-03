data "aws_caller_identity" "current" {}

# S3 Bucket to store Terraform state files 
resource "aws_s3_bucket" "terraform_state" {
  bucket        = "tf-state-bucket-9876"
  force_destroy = true
}

# KMS key for server side encryption
resource "aws_kms_key" "state-key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 7
}

# KMS key policy
resource "aws_kms_key_policy" "state-key-policy" {
  key_id = aws_kms_key.state-key.id
  policy = jsonencode({
    Id = "example"
    Statement = [
      {
        Action = [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey",
          "kms:ReEncryptFrom",
          "kms:ReEncryptTo",
          "kms:PutKeyPolicy",
          "kms:ScheduleKeyDeletion",
          "kms:EnableKey",
          "kms:DisableKey",
          "kms:TagResource"
        ]
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }

        Resource = aws_kms_key.state-key.arn

        Sid = "Enable IAM User Permissions"
      },
    ]
    Version = "2012-10-17"
  })
  depends_on = [aws_kms_key.state-key]
}

# S3 bucket versioning for state file
resource "aws_s3_bucket_versioning" "state-bucket-versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 bucket policy to block public access to state bucket
resource "aws_s3_bucket_public_access_block" "s3-policy-block" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket_server_side_encryption_configuration" "s3-state-sse" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.state-key.arn
      sse_algorithm     = "aws:kms"
    }
  }
  depends_on = [aws_kms_key.state-key]

}

# DynamoDB for Statefile locking

resource "aws_dynamodb_table" "state-dynamodb-table" {
  name         = "state-db"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockId"

  attribute {
    name = "LockId"
    type = "S"
  }

  tags = {
    Name        = "dynamodb-table-1"
    Environment = "production"
  }
}


