# Terraform State S3 bucket


# AWS Region
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-1"
}

# DynamoDB table name

# ARN of IAM USER
variable "iam_arn" {
  description = "ARN for terraform IAM user"
  type        = string
  default     = "arn:aws:iam::337909752243:user/terraform-user"
}
