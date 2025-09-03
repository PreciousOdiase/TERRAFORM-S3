# S3 Bucket to store Terraform state files
resource "aws_s3_bucket" "terraform_state" {
  bucket = "tf-state-bucket-9876"
}

# KMS Key for server-side encryption
resource "aws_kms_key" "state-key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 3
}

# KMS Key Policy
resource "aws_kms_key_policy" "state-key-policy" {
  key_id = aws_kms_key.state-key.id
  policy = jsonencode({
    Id      = "example"
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = var.iam_arn
        }
        Action = [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey",
          "kms:ReEncryptFrom",
          "kms:ReEncryptTo"
        ]
        Resource = "*"
      }
    ]
  })

  depends_on = [aws_kms_key.state-key]
}

# S3 Bucket Versioning for State File
resource "aws_s3_bucket_versioning" "state-bucket-versioning" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# S3 Bucket Public Access Block
resource "aws_s3_bucket_public_access_block" "s3-policy-block" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# S3 Bucket Server-Side Encryption Configuration
resource "aws_s3_bucket_server_side_encryption_configuration" "s3-state-sse" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.state-key.arn
    }
  }

  depends_on = [aws_kms_key.state-key]
}

# DynamoDB for Statefile Locking
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

